Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab1F2Pk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:40:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51698 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab1F2Ph4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <1309212931-19772-1-git-send-email-richard@nod.at>
References: <1309212931-19772-1-git-send-email-richard@nod.at>
Date: Wed, 29 Jun 2011 18:37:54 +0300
Message-ID: <BANLkTikauFJtuCo5E3=tb_=cwVS3sF35zw@mail.gmail.com>
Subject: Re: [PATCH 1/4] um: Fix _FORTIFY_SOURCE=2 support for kernel modules
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 1:15 AM, Richard Weinberger <richard@nod.at> wrote:
> When UML is compiled with _FORTIFY_SOURCE we have to
> export all _chk() functions which are used in modules.
> For now it's only the case for __sprintf_chk().
>
> Tested-by: Florian Fainelli <florian@openwrt.org>
> Reported-by: Florian Fainelli <florian@openwrt.org>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/um/os-Linux/user_syms.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/arch/um/os-Linux/user_syms.c b/arch/um/os-Linux/user_syms.c
> index 05f5ea8..45ffe46 100644
> --- a/arch/um/os-Linux/user_syms.c
> +++ b/arch/um/os-Linux/user_syms.c
> @@ -113,3 +113,8 @@ EXPORT_SYMBOL(__stack_smash_handler);
>
>  extern long __guard __attribute__((weak));
>  EXPORT_SYMBOL(__guard);
> +
> +#ifdef _FORTIFY_SOURCE
> +extern int __sprintf_chk(char *str, int flag, size_t strlen, const char *format);
> +EXPORT_SYMBOL(__sprintf_chk);
> +#endif
> --

Can you please clarify why it's needed? I use FORTIFY_SOURCES on
Linus' tree UML on Ubuntu w/ no problems and w/o this patch...

Thanks,
Vitaliy
