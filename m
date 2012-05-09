Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab2EIIjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:39:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39838 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab2EIIjF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:39:05 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1334203443-30011-1-git-send-email-dwalker@fifo99.com>
References: <1334203443-30011-1-git-send-email-dwalker@fifo99.com>
Date: Wed, 9 May 2012 01:39:05 -0700
Message-ID: <CAOesGMiHfQwWXSQwvcEPxY63FEjbsB7ux4dHvAPM99Kf43cDZw@mail.gmail.com>
Subject: Re: [PATCH 1/2] arm: msm: fix up very basic HTC Sapphire support
From: Olof Johansson <olof@lixom.net>
To: Daniel Walker <dwalker@fifo99.com>
Cc: David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 11, 2012 at 9:04 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> Adds sapphire into the make file, and fixes all the code problems that
> prevented it from building (including adding board-sapphire.h)
>
> Signed-off-by: Daniel Walker <dwalker@fifo99.com>
> ---
>  arch/arm/mach-msm/Kconfig          |   10 +-
>  arch/arm/mach-msm/Makefile         |    1 +
>  arch/arm/mach-msm/board-sapphire.c |   18 +--
>  arch/arm/mach-msm/board-sapphire.h |  224 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 235 insertions(+), 18 deletions(-)
>  create mode 100644 arch/arm/mach-msm/board-sapphire.h
>
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 1cd40ad..04f3b8e 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -6,7 +6,6 @@ choice
>
>  config ARCH_MSM7X00A
>        bool "MSM7x00A / MSM7x01A"
> -       select MACH_TROUT if !MACH_HALIBUT
>        select ARCH_MSM_ARM11
>        select MSM_SMD
>        select MSM_SMD_PKG3
> @@ -80,6 +79,7 @@ config  MSM_VIC
>  menu "Qualcomm MSM Board Type"
>
>  config MACH_HALIBUT
> +       select MACH_TROUT if !MACH_SAPPHIRE && !MACH_HALIBUT

This doesn't seem to make much sense here.

>        depends on ARCH_MSM
>        depends on ARCH_MSM7X00A
>        bool "Halibut Board (QCT SURF7201A)"
> @@ -93,6 +93,14 @@ config MACH_TROUT
>        help
>          Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
>
> +config MACH_SAPPHIRE
> +       select MACH_TROUT if !MACH_HALIBUT && !MACH_SAPPHIRE

Nor does this.

I presume these are here to make sure that at least one of the boards
is selected. There are already build checks to make sure that at least
one machine entry exists, so if a user mis-configures his kernel he
will hit a build error. Seems as reasonable as any catch for this.

If you feel strongly that you need to select at least one board, then
do so at the ARCH_ level, not on every board option.


Thanks,

-Olof
