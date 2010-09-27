Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab0I0Cks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 22:40:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41846 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177Ab0I0Ckr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 22:40:47 -0400
Date: Sun, 26 Sep 2010 22:40:44 -0400
From: Kyle McMartin <kyle@redhat.com>
To: James Dingwall <james.dingwall@amdocs.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        stable@kernel.org
Subject: Re: Re: PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just after the
 boot
Message-ID: <20100927024044.GQ13116@bombadil.infradead.org>
References: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 04:23:55PM +0100, James Dingwall wrote:
> > I was experiencing the same immediate crash with a null pointer
> > dereference (log below) on boot with 2.6.35.5.  Reverting
> > fb412a178502dc498430723b082a932f797e4763 also resolved the problem for
> > me.
> 
> Checking the diff from this commit it looks like there is a typo in the patch.  With the following (probably mangled by my client) I get 2.6.35.5 to boot.  Suggest it should be a candidate for .32 and .35 stable trees.
> 

Greg, a spelling mistake cropped into this patch during 2.6.35.5 that
James here points out. Adding you to CC since it seems to have missed
stable 2.6.35.6...

Was in xen-use-percpu-interrupts-for-ipis-and-virqs.patch.

--Kyle

> --- drivers/xen/events.c.orig   2010-09-23 16:10:34.257124313 +0100
> +++ drivers/xen/events.c        2010-09-23 16:10:44.326194462 +0100
> @@ -935,7 +935,7 @@
>  	.retrigger		= retrigger_dynirq,
>  };
> 
> -static struct irq_chip en_percpu_chip __read_mostly = {
> +static struct irq_chip xen_percpu_chip __read_mostly = {
>  	.name			= "xen-percpu",
> 
>  	.disable		= disable_dynirq,
> 
> James
> This message and the information contained herein is proprietary and confidential and subject to the Amdocs policy statement,
> you may review at http://www.amdocs.com/email_disclaimer.asp
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
