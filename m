Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab1JQLg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:36:27 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:3198 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1JQLg0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:4:1>);
	Mon, 17 Oct 2011 07:36:26 -0400
Message-Id: <4E9C2F52020000780005BA4C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 17 Oct 2011 12:36:18 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <hch@infradead.org>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] xen/blkback: Support 'feature-barrier' aka
	 old-style BARRIER requests.
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
 <1318260494-27985-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1318260494-27985-2-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 10.10.11 at 17:28, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> @@ -481,6 +503,10 @@ static void __end_block_io_op(struct pending_req 
> *pending_req, int error)
>  			      pending_req->operation, pending_req->status);
>  		xen_blkif_put(pending_req->blkif);
>  		free_req(pending_req);
> +		if (atomic_read(&pending_req->blkif->refcnt) <= 2) {
> +			if (atomic_read(&pending_req->blkif->drain))
> +				complete(&pending_req->blkif->drain_complete);
> +		}

Shouldn't this be done *before* the call the free_req()? Or
alternatively a local copy of pending_req->blkif be obtained before
freeing pending_req (which could be used in a couple more places
in this function)?

Jan

