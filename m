Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1GNOxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 10:53:17 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41533
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754696Ab1GNOxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 10:53:16 -0400
Date: Thu, 14 Jul 2011 10:53:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Naohiro Aota <naota@elisp.net>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@tuxera.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Anton Salikhmetov <alexo@tuxera.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hfsplus: Add record offset check
Message-ID: <20110714145313.GA16776@infradead.org>
References: <87mxgku044.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mxgku044.fsf@elisp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> diff --git a/fs/hfsplus/brec.c b/fs/hfsplus/brec.c
> index 2312de3..5c51d04 100644
> --- a/fs/hfsplus/brec.c
> +++ b/fs/hfsplus/brec.c
> @@ -43,6 +43,10 @@ u16 hfs_brec_keylen(struct hfs_bnode *node, u16 rec)
>  			node->tree->node_size - (rec + 1) * 2);
>  		if (!recoff)
>  			return 0;
> +		if (recoff >= node->tree->node_size) {
> +			printk(KERN_ERR "hfs: recoff %d too large\n", recoff);
> +			return 0;
> +		}

As non-obvious as it sounds 0 is indded the canonical error return from
hfs_brec_keylen, so that patch looks good to me.  Can you resend it
with a better title and description mentioning better validatation of
the on-disk structures? 

