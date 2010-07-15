Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab0GOGoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 02:44:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36766 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab0GOGoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 02:44:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R86k6MwW2RK1qhfdD5C9oON922YbWJzQJ4D5+FLvTQ0lDXblTJ83abmCMbn3IJCGIP
         Kx/lxAKO4elrS2Msvjv6xyVvMeCSW3QFo0IsG6f87lFUYKDBLawGAehQO7IAdWTX8SrI
         cH9ORhc3VQmavZYqP8L7NbzwNLjDmW9Xxwkig=
Date: Thu, 15 Jul 2010 10:43:54 +0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: kernel-janitors@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
        John Kacur <jkacur@redhat.com>, Tejun Heo <tj@kernel.org>,
        Maxim Kuvyrkov <maxim@codesourcery.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] arch/m68knommu/kernel/process.c: formatting of
 pointers in printk()
Message-ID: <20100715064354.GA5555@albatros>
References: <1279130473-10737-1-git-send-email-segooon@gmail.com>
 <4C3E5672.4090606@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3E5672.4090606@snapgear.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 10:29 +1000, Greg Ungerer wrote:
> Hi Kulikov,
> 
> Kulikov Vasiliy wrote:
> >Use %p instead of %08x in printk().
> >
> >Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> 
> Acked-by: Greg Ungerer <gerg@uclinux.org>
> 
> Do you want me to push this to Linus via the m68knommu git tree?
Yeah, it would be good.

> 
> Regards
> Greg
> 
> 
> 
> >---
> > arch/m68knommu/kernel/process.c |   10 +++++-----
> > 1 files changed, 5 insertions(+), 5 deletions(-)
> >
> >diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
> >index 6aa6613..1096c0e 100644
> >--- a/arch/m68knommu/kernel/process.c
> >+++ b/arch/m68knommu/kernel/process.c
> >@@ -316,14 +316,14 @@ void dump(struct pt_regs *fp)
> > 		fp->d0, fp->d1, fp->d2, fp->d3);
> > 	printk(KERN_EMERG "d4: %08lx    d5: %08lx    a0: %08lx    a1: %08lx\n",
> > 		fp->d4, fp->d5, fp->a0, fp->a1);
> >-	printk(KERN_EMERG "\nUSP: %08x   TRAPFRAME: %08x\n",
> >-		(unsigned int) rdusp(), (unsigned int) fp);
> >+	printk(KERN_EMERG "\nUSP: %08x   TRAPFRAME: %p\n",
> >+		(unsigned int) rdusp(), fp);
> > 	printk(KERN_EMERG "\nCODE:");
> > 	tp = ((unsigned char *) fp->pc) - 0x20;
> > 	for (sp = (unsigned long *) tp, i = 0; (i < 0x40);  i += 4) {
> > 		if ((i % 0x10) == 0)
> >-			printk(KERN_EMERG "%08x: ", (int) (tp + i));
> >+			printk(KERN_EMERG "%p: ", tp + i);
> > 		printk("%08x ", (int) *sp++);
> > 	}
> > 	printk(KERN_EMERG "\n");
> >@@ -332,7 +332,7 @@ void dump(struct pt_regs *fp)
> > 	tp = ((unsigned char *) fp) - 0x40;
> > 	for (sp = (unsigned long *) tp, i = 0; (i < 0xc0); i += 4) {
> > 		if ((i % 0x10) == 0)
> >-			printk(KERN_EMERG "%08x: ", (int) (tp + i));
> >+			printk(KERN_EMERG "%p: ", tp + i);
> > 		printk("%08x ", (int) *sp++);
> > 	}
> > 	printk(KERN_EMERG "\n");
> >@@ -341,7 +341,7 @@ void dump(struct pt_regs *fp)
> > 	tp = (unsigned char *) (rdusp() - 0x10);
> > 	for (sp = (unsigned long *) tp, i = 0; (i < 0x80); i += 4) {
> > 		if ((i % 0x10) == 0)
> >-			printk(KERN_EMERG "%08x: ", (int) (tp + i));
> >+			printk(KERN_EMERG "%p: ", tp + i);
> > 		printk("%08x ", (int) *sp++);
> > 	}
> > 	printk(KERN_EMERG "\n");
> 
> 
> -- 
> ------------------------------------------------------------------------
> Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
> SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
> 8 Gardner Close                             FAX:         +61 7 3217 5323
> Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
