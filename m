Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab0CPSj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:39:26 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:39136 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab0CPSjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=PxJwFqMBw75HoDjbbP5Gb0vtW0/dt3Z+KJH64ZKI6FEpxRog03KC0esm0Lac2jPcjh
         DDpkF7itfQSKRO2k2LwglolaZu7VG3t6v9tMmjRoTdO1HTOHMugGvD2ldWvZ5CNCWl1Z
         /20KFLDs3b0sYjWYjwHWlyXyRXMDZ5unUew/g=
From: "Will L Givens" <wlgivens@gmail.com>
To: <dl8bcu@dl8bcu.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-alpha@vger.kernel.org>
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com> <001e01cac4cc$98072ce0$c81586a0$@com> <20100316182534.GA818@ds20.borg.net>
In-Reply-To: <20100316182534.GA818@ds20.borg.net>
Subject: RE: Will's kernel compilation error
Date: Tue, 16 Mar 2010 13:38:55 -0500
Message-ID: <004f01cac537$f099e0d0$d1cda270$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcrFNhl8KrkdG7LvSKK2DGZm4H05nQAAZXiw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Thanks!!! I'll give that a shot, this is one of the files that I
experimented on but I was setting the linker flags. Didn't think to simply
remove -msmall-data CFLAG!

