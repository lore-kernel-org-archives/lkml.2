Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab0GOAHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:07:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44221 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0GOAHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:07:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=abqEzQjou1gQQ3VG1vAU+XWbQaUTJG0aXMbxOsS8LXFYLYO779KfNaVIHZWThS5UFf
         EAH+C5bpIAEFci7Bgxl8Bygf2WuGDUMX+M+v4I9+1v7IDWhn2XRPWnhiNMUcSinYpbVU
         IRBe4mDNhE7qVlglE7Rh8Y+etzCLCLJM7FwRc=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Bugzilla # 16395: Regression in 2.6.35-rc4 since commit 0b28bac5aef7bd1ab213723df031e61db9ff151a on HP Mini 110 Netbook
Date: Wed, 14 Jul 2010 17:07:35 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc5+; KDE/4.4.5; x86_64; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <4C3E4F2F.3090404@lwfinger.net>
In-Reply-To: <4C3E4F2F.3090404@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007141707.37234.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 14, 2010 04:58:39 pm Larry Finger wrote:
> Since the commit in the title, a kernel built on an HP Mini 110 Netbook no
> longer has keyboard input. The main difference is that CONFIG_SERIO_I8042
> is no longer defined. When this equal yes, the keyboard works. The faulty
> commit was located by bisection and has been verified by reverting the
> patch.
> 
> Further investigation shows that the faulty hunk is
> 
> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
> index 3bfe8fa..256b9e9 100644
> --- a/drivers/input/serio/Kconfig
> +++ b/drivers/input/serio/Kconfig
> @@ -22,7 +22,7 @@ config SERIO_I8042
>          tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
>          default y
>          depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
> -                  (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
> +                  (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN &&
> !X86_MRST help
>            i8042 is the chip over which the standard AT keyboard and PS/2
>            mouse are connected to the computer. If you use these devices,
> 
> Reverting this one hunk alone results in a working system. Obviously, this
> Netbook does not have X86_MRST set.


You meant to say "does have CONFIG_X86_MRST set", right?

Thanks.

-- 
Dmitry
