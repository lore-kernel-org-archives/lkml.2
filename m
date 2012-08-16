Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab2HPHxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:53:55 -0400
Received: from mga06.intel.com ([134.134.136.21]:46261 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755776Ab2HPHxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:53:49 -0400
Subject: Re: [RESEND][PATCH]efi: initialize efi.runtime_version to make
 query_variable_info/update_capsule workable
From: Matt Fleming <matt.fleming@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "H. Peter Anvin (hpa@linux.intel.com)" <hpa@linux.intel.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "Paul Gortmaker (paul.gortmaker@windriver.com)" 
	<paul.gortmaker@windriver.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB5C7C3@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB5C7C3@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 16 Aug 2012 08:53:18 +0100
Message-ID: <1345103598.3088.14.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-06 at 18:37 +0000, Seiji Aguchi wrote:
> A value of efi.runtime_version is checked before calling
> update_capsule()/query_variable_info() as follows.
> But it isn't initialized anywhere.
> <snip>
> static efi_status_t virt_efi_query_variable_info(u32 attr,
>                                                  u64 *storage_space,
>                                                   u64 *remaining_space,
>                                                  u64 *max_variable_size) {
>         if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
>                 return EFI_UNSUPPORTED; 
> <snip>
> 
> This patch initializes a value of efi.runtime_version at boot time.
> 
> Acked-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  arch/x86/platform/efi/efi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Thanks, I picked this up just so it doesn't get lost. It will probably
go to Linus via Peter Anvin.

