Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2AELVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:21:38 -0500
Received: from mga07.intel.com ([143.182.124.22]:35900 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751591Ab2AELVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:21:36 -0500
Subject: Re: [PATCH 5/5] x86: efi: allow basic init with mixed 32/64-bit
 efi/kernel
From: Matt Fleming <matt.fleming@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
In-Reply-To: <1325610682-24811-6-git-send-email-olof@lixom.net>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
	 <1325610682-24811-6-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 05 Jan 2012 11:21:23 +0000
Message-ID: <1325762483.3635.21.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 09:11 -0800, Olof Johansson wrote:
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
>  arch/x86/platform/efi/efi.c |  234 ++++++++++++++++++++++++++++++++-----------
>  include/linux/efi.h         |   45 ++++++++
>  4 files changed, 228 insertions(+), 63 deletions(-)

This needs resubmitting as you're undoing the changes you've made in
PATCH 2/5, i.e. stuff like this,

> @@ -254,7 +257,7 @@ int efi_set_rtc_mmss(unsigned long nowtime)
>  
>  	status = efi.get_time(&eft, &cap);
>  	if (status != EFI_SUCCESS) {
> -		pr_err("Oops: efitime: can't read time!\n");
> +		printk(KERN_ERR "Oops: efitime: can't read time!\n");
>  		return -1;
>  	}


