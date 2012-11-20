Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2KTQBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:01:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48650 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2KTQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:01:42 -0500
MIME-Version: 1.0
In-Reply-To: <1353422714-18327-1-git-send-email-pizza@shaftnet.org>
References: <1353422714-18327-1-git-send-email-pizza@shaftnet.org>
Date: Wed, 21 Nov 2012 00:01:40 +0800
Message-ID: <CACVXFVM=+Gus1_6U82G6_mszoRNsqb24Y+F7UPPLPBgzQasaew@mail.gmail.com>
Subject: Re: [PATCH] [firmware_class] Fix compile with no builtin firmware
From: Ming Lei <tom.leiming@gmail.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 10:45 PM, Solomon Peachy <pizza@shaftnet.org> wrote:
> When compiling the firmware loader, the builtin firmware functions were
> erroneously compiled as they were wrapped with CONFIG_FW_LOADER instead
> of CONFIG_FIRMWARE_IN_KERNEL.  This is normally harmless, except when
> there was actually no firmware to compile into the kernel, causing the
> build to fail with a linking error:
>
> drivers/built-in.o: In function `release_firmware':
> (.text+0x192e2): undefined reference to `__end_builtin_fw'
> drivers/built-in.o: In function `release_firmware':
> (.text+0x19304): undefined reference to `__end_builtin_fw'
> drivers/built-in.o: In function `_request_firmware':
> firmware_class.c:(.text+0x1986c): undefined reference to `__end_builtin_fw'
> firmware_class.c:(.text+0x19886): undefined reference to `__end_builtin_fw'
> firmware_class.c:(.text+0x19a98): undefined reference to `__end_builtin_fw'
> drivers/built-in.o: In function `release_firmware':
> (.text+0x192dc): undefined reference to `__start_builtin_fw'
> drivers/built-in.o: In function `_request_firmware':
> firmware_class.c:(.text+0x19860): undefined reference to `__start_builtin_fw'
> firmware_class.c:(.text+0x19a8a): undefined reference to `__start_builtin_fw'

I have tried to reproduce the compile failure but not succeed, could you share
your .config?

>
> This trivial patch fixes this oversight.
>
> Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
> CC: stable@vger.kernel.org
> ---
>  drivers/base/firmware_class.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 8945f4e..3474e7f 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -38,7 +38,7 @@ MODULE_LICENSE("GPL");
>
>  /* Builtin firmware support */
>
> -#ifdef CONFIG_FW_LOADER
> +#ifdef CONFIG_FIRMWARE_IN_KERNEL

This might not be correct when EXTRA_FIRMWARE is set and
CONFIG_FIRMWARE_IN_KERNEL is unset.

Thanks,
-- 
Ming Lei
