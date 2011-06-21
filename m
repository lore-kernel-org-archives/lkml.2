Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab1FUTbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 15:31:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35058 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab1FUTbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 15:31:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=hAYwcCoteNiyOEfLAFBT1kHbqbgqlUX8SxM6hIBZqlwb5hlhJs34YqjF6EykBwsBnA
         TeMJTAtGKDcxKrXZjJ5ENvhjG9H4xXIJexOB4SpnW3UWUQCe6/uRSFQHf1RUjtREDlrQ
         9Ya/azXY8/girVgb6SCgSQB5t49CyGpyONAsw=
MIME-Version: 1.0
In-Reply-To: <201106211209.46462.hartleys@visionengravers.com>
References: <201106211209.46462.hartleys@visionengravers.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 21 Jun 2011 15:31:20 -0400
X-Google-Sender-Auth: TFIuER0TYPMWeVanig51IEzDDGQ
Message-ID: <BANLkTi=8mstQAWKxBBBFH_+byGoXr8ieRg@mail.gmail.com>
Subject: Re: [PATCH] ARM: quiet sparse noise due to __ARCH_WANT_SYS_RT_SIG(ACTION|SUSPEND)
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, mikpe@it.uu.se,
        ebiederm@xmission.com, tony.luck@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 15:09, H Hartley Sweeten wrote:
> --- a/arch/arm/include/asm/unistd.h
> +++ b/arch/arm/include/asm/unistd.h
> @@ -467,6 +467,20 @@
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/types.h>
> +#include <linux/linkage.h>
> +#include <linux/compiler.h>
> +#include <linux/signal.h>
> +
> +asmlinkage long sys_rt_sigaction(int sig, const struct sigaction __user *act,
> +                                struct sigaction __user *oact,
> +                                size_t sigsetsize);
> +asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize);
> +
> +#endif /* !__ASSEMBLY__ */

yikes ... this really the only way to fix the sparse warning ?
-mike
