Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab0CPVXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:23:36 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:36930 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab0CPVXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:23:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=X5OfM++9RJYt1esTyC0s1wci70pg1CTAzgdnWeyXlO89amaSIumHxHTM6cOpVNs1vd
         wu0APtHC6kOgeczUc+eDNeIlruU6zWbKjnB8+LPXsTS5qt2c96Ruj0EpqDQkLpiMlgF/
         ybwJZQKWkTduX8GlCGL13f2uNPRMOgUGK+IhQ=
From: "Will L Givens" <wlgivens@gmail.com>
To: <dl8bcu@dl8bcu.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-alpha@vger.kernel.org>
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com> <001e01cac4cc$98072ce0$c81586a0$@com> <20100316182534.GA818@ds20.borg.net>
In-Reply-To: <20100316182534.GA818@ds20.borg.net>
Subject: RE: Will's kernel compilation error
Date: Tue, 16 Mar 2010 16:23:01 -0500
Message-ID: <006e01cac54e$dd6b7b10$98427130$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcrFNhl8KrkdG7LvSKK2DGZm4H05nQAFxZlg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > It seems the problem, GPREL16, is pretty wide spread. I've tried
> building
> > the drivers as modules, since that doesn't appear to be a problem
> *knock on
> > wood* but one driver after another, after another, after another
> generates a
> > new GPREL16 error! Raid0 drivers, numerous NetFilter modules, IR
> drivers
> > (guess I can't use a Hauppauge card), and various other components.
> I'm
> > going to try a few more configurations... then hit the sack. I'm
> pretty sure
> > this is going to be a long process.
> 
> when I hit the relocation overflow a couple of releases before, I
> locally
> applied this patch, which fixes it for me. I assume the kernel is
> slightly
> bigger this way, but I didn't measure it.
> 
> ev6, everything built in, gcc 4.4 I think
> 
> Thorsten
> 
> 
> diff --git a/arch/alpha/Makefile b/arch/alpha/Makefile
> index 4759fe7..2cc3cc5 100644
> --- a/arch/alpha/Makefile
> +++ b/arch/alpha/Makefile
> @@ -12,7 +12,7 @@ NM := $(NM) -B
> 
>  LDFLAGS_vmlinux	:= -static -N #-relax
>  CHECKFLAGS	+= -D__alpha__ -m64
> -cflags-y	:= -pipe -mno-fp-regs -ffixed-8 -msmall-data
> +cflags-y	:= -pipe -mno-fp-regs -ffixed-8
>  cflags-y	+= $(call cc-option, -fno-jump-tables)
> 
>  cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4
> 
> 
> --
> | Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de
> |
> | Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle,
> Germany  |
> | Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org
> [44.130.8.19] |

That patch did the trick!!!! Everything built without issue... I'll post
your patch at bugzilla.kernel.org. Now, just have to test the AIC7xxx driver
and see if it works!  Nope it doesn't, same error as before... aic7xxx
unable to handle kernel paging address at 036b***** I'm going to try
swapping some memory around and see what happens if anything.



