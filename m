Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0K2VHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:07:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43592 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab0K2VHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:07:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZcElgCPsTL7fheUaj604qw5L+d0kI7kfMwdNZPqYTRN3dAbVOdVheltqcQZWWgxygU
         IiHwI+SPdQKjxhrWEXOpGFp3Mbf9RnhEya2XME84FC2/oL+7pklD7j3EmpfWyUdV7SmQ
         VFURpxn/A0ouKJN0sS8iMC3ubWzzVVd7Dif1E=
MIME-Version: 1.0
In-Reply-To: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
Date: Mon, 29 Nov 2010 16:07:20 -0500
Message-ID: <AANLkTinpX0p8hv_RJojASbjDNYQ60bODo3kLBobRDtmf@mail.gmail.com>
Subject: Re: [PATCH] Built kernel without -O2 option
From: Arnaud Lacombe <lacombar@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org, gdb@sourceware.org, hellogcc@freelists.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Nov 28, 2010 at 10:56 PM, Hui Zhu <teawater@gmail.com> wrote:
> Hi,
>
> Now, there are a lot of ways to debug the Linux kernel with GDB, like
> qemu, kgtp or kgdb and so on.
> But the developer more like add a printk. It have a lot of reason, a big one is:
> (gdb) p ret
> $3 = <value optimized out>
> And the code execution order is not right.
>
> This is becuase the Kernel is bult with gcc -O2.  Gcc will not
> generate enough debug message with file with -O2.
> So GDB cannot work very well with Linux kernel.
>
> So I make a patch that add a option in "Kernel hacking" called "Close
> GCC optimization".  It will make kernel be built without -O2.
>
no, it does not, see below ..

> I built and use it in i386 and x86_64.  I will try to make it OK in other arch.
>
> And I will put new patch in here and
> http://code.google.com/p/kgtp/downloads/list
>
> Thanks,
> Hui
>
> Signed-off-by: Hui Zhu <teawater@gmail.com>
> ---
> [...]
> +ifdef CONFIG_CC_CLOSE_OPTIMIZATION
> +CFLAGS_process_$(BITS).o       += -O2
> +CFLAGS_entry_$(BITS).o         += -O2
> +CFLAGS_traps.o                 += -O2
> +CFLAGS_i387.o                  += -O2
> +CFLAGS_xsave.o                 += -O2
> +CFLAGS_hpet.o                  += -O2
> +endif
>
> [...]
>
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -136,6 +136,14 @@ config DEBUG_SECTION_MISMATCH
>          - Enable verbose reporting from modpost to help solving
>            the section mismatches reported.
>
> +config CC_CLOSE_OPTIMIZATION
> +       bool "Close GCC optimization"
> +       default n
> +       help
> +         Enabling this option will let gcc build kernel without "-O2".
> +
> +         If unsure, say N.
> +
You are not consistent with yourself, you add an option saying "do not
build the kernel with -O2" and yet, you add "-O2" flags for unknown
reason all over the tree...

 - Arnaud
