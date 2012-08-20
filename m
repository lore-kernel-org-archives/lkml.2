Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab2HTKNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 06:13:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52296 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2HTKNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 06:13:20 -0400
Message-ID: <50320DBD.5080507@canonical.com>
Date: Mon, 20 Aug 2012 12:13:17 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, mk@dee.su,
        Marko Kohtala <marko.kohtala@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] x86: efi: Turn off efi_enabled after setup on mixed fw/kernel
References: <1345412920-10906-1-git-send-email-olof@lixom.net>
In-Reply-To: <1345412920-10906-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 19-08-12 23:48, Olof Johansson schreef:
> When 32-bit EFI is used with 64-bit kernel (or vice versa), turn off
> efi_enabled once setup is done. Beyond setup, it is normally used to
> determine if runtime services are available and we will have none.
>
> This will resolve issues stemming from efivars modprobe panicking on a
> 32/64-bit setup, as well as some reboot issues on similar setups.
>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: stable@kernel.org # 3.4 and 3.5
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> ---
>  arch/x86/kernel/setup.c     | 11 +++++++++++
>  arch/x86/platform/efi/efi.c | 14 ++++++++------
>  2 files changed, 19 insertions(+), 6 deletions(-)
> <snip>
>  
> +static inline bool efi_is_native(void)
> +{
> +	return !(IS_ENABLED(CONFIG_X86_64) ^ efi_64bit);
> +}
>
Isn't this just a more complicated way of writing
IS_ENABLED(CONFIG_X86_64) == efi_64bit ?

Also moving the assignment to efi_init will make it no longer call
efi_reserve_boot_services, I don't know if that is intentional or not,
but something to consider at least since it's a behavioral change.

>From a quick glance with some grepping, efi reboot and efifb will
also no longer work, is that intentional?

~Maarten

