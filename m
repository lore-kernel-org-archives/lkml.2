Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1BAKDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:03:11 -0500
Received: from ra.se.axis.com ([195.60.68.13]:35561 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab1BAKDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:03:09 -0500
Date: Tue, 1 Feb 2011 11:03:05 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: David Miller <davem@davemloft.net>
Cc: "richm@oldelvet.org.uk" <richm@oldelvet.org.uk>,
        "609371@bugs.debian.org" <609371@bugs.debian.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jeffm@suse.com" <jeffm@suse.com>
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110201100305.GF9874@axis.com>
References: <20110115.211722.39173519.davem@davemloft.net> <20110116.220755.179947617.davem@davemloft.net> <20110117090557.GF9874@axis.com> <20110131.211116.115946085.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110131.211116.115946085.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 06:11:16AM +0100, David Miller wrote:
> Jesper, could you please review this?

Looks good!

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> --------------------
> klist: Fix object alignment on 64-bit.
> 
> Commit c0e69a5bbc6fc74184aa043aadb9a53bc58f953b ("klist.c: bit 0 in
> pointer can't be used as flag") intended to make sure that all klist
> objects were at least pointer size aligned, but used the constant "4"
> which only works on 32-bit.
> 
> Use "sizeof(void *)" which is correct in all cases.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/include/linux/klist.h b/include/linux/klist.h
> index e91a4e5..a370ce5 100644
> --- a/include/linux/klist.h
> +++ b/include/linux/klist.h
> @@ -22,7 +22,7 @@ struct klist {
>  	struct list_head	k_list;
>  	void			(*get)(struct klist_node *);
>  	void			(*put)(struct klist_node *);
> -} __attribute__ ((aligned (4)));
> +} __attribute__ ((aligned (sizeof(void *))));
>  
>  #define KLIST_INIT(_name, _get, _put)					\
>  	{ .k_lock	= __SPIN_LOCK_UNLOCKED(_name.k_lock),		\
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
