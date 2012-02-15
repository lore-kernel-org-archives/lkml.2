Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab2BONdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:33:49 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:45330 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759191Ab2BONdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:33:45 -0500
Subject: Re: [PATCH v5 5/5] x86: efi: allow basic init with mixed 32/64-bit
 efi/kernel
From: Matt Fleming <matt@console-pimps.org>
To: Olof Johansson <olof@lixom.net>
Cc: x86@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mjg@redhat.com
In-Reply-To: <1329081869-20779-6-git-send-email-olof@lixom.net>
References: <1329081869-20779-1-git-send-email-olof@lixom.net>
	 <1329081869-20779-6-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Feb 2012 13:33:42 +0000
Message-ID: <1329312822.3675.126.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-12 at 13:24 -0800, Olof Johansson wrote:
> Traditionally the kernel has refused to setup EFI at all if there's been
> a mismatch in 32/64-bit mode between EFI and the kernel.
> 
> On some platforms that boot natively through EFI (Chrome OS being one),
> we still need to get at least some of the static data such as memory
> configuration out of EFI. Runtime services aren't as critical, and
> it's a significant amount of work to implement switching between the
> operating modes to call between kernel and firmware for thise cases. So
> I'm ignoring it for now.
> 
> v5:
> * Fixed some printk strings based on feedback
> * Renamed 32/64-bit specific types to not have _ prefix
> * Fixed bug in printout of efi runtime disablement
> 
> v4:
> * Some of the earlier cleanup was accidentally reverted by this patch, fixed.
> * Reworded some messages to not have to line wrap printk strings
> 
> v3:
> * Reorganized to a series of patches to make it easier to review, and
>   do some of the cleanups I had left out before.
> 
> v2:
> * Added graceful error handling for 32-bit kernel that gets passed
>   EFI data above 4GB.
> * Removed some warnings that were missed in first version.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  arch/x86/include/asm/efi.h  |    2 +-
>  arch/x86/kernel/setup.c     |   10 ++-
>  arch/x86/platform/efi/efi.c |  164 +++++++++++++++++++++++++++++++++++++------
>  include/linux/efi.h         |   45 ++++++++++++
>  4 files changed, 196 insertions(+), 25 deletions(-)

Acked-by: Matt Fleming <matt.fleming@intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center

