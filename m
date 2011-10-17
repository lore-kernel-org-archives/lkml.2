Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1JQNXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:23:09 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40323 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1JQNXH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:6:1>);
	Mon, 17 Oct 2011 09:23:07 -0400
Message-Id: <4E9C4855020000780005BA73@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 17 Oct 2011 14:23:01 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Ian Campbell" <Ian.Campbell@citrix.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Dong Yang Li" <lidongyang@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance
	 discard support with secure erasing support.
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
 <1318263187.21903.464.camel@zakaz.uk.xensource.com>
 <20111010164250.GG28646@phenom.oracle.com>
 <1318274402.27397.13.camel@dagon.hellion.org.uk>
 <20111010195749.GA5755@phenom.oracle.com>
 <4E940E21020000780005AA29@nat28.tlf.novell.com>
 <20111011155133.GC29349@phenom.oracle.com>
 <20111011205729.GB22668@phenom.oracle.com>
In-Reply-To: <20111011205729.GB22668@phenom.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.10.11 at 22:57, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
>...
> @@ -705,7 +711,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
>  static void blkif_completion(struct blk_shadow *s)
>  {
>  	int i;

This function gets called for all types of requests, and hence must filter
discard ones now that what would be nr_segments can be non-zero,
e.g.

	if (s->req.operation == BLKIF_OP_DISCARD)
		return;

Jan

> -	for (i = 0; i < s->req.nr_segments; i++)
> +	for (i = 0; i < s->req.u1.nr_segments; i++)
>  		gnttab_end_foreign_access(s->req.u.rw.seg[i].gref, 0, 0UL);
>  }
>  


