Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933456Ab2HPVo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:44:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:27974 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933422Ab2HPVoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:44:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,781,1336374000"; 
   d="scan'208";a="203041948"
Message-ID: <502D6982.4090100@linux.intel.com>
Date: Thu, 16 Aug 2012 14:43:30 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Matt Fleming <matt.fleming@intel.com>
CC: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "olof@lixom.net" <olof@lixom.net>,
        "Paul Gortmaker (paul.gortmaker@windriver.com)" 
	<paul.gortmaker@windriver.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RESEND][PATCH]efi: initialize efi.runtime_version to make query_variable_info/update_capsule
 workable
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB5C7C3@USINDEM103.corp.hds.com> <1345103598.3088.14.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1345103598.3088.14.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 12:53 AM, Matt Fleming wrote:
> On Mon, 2012-08-06 at 18:37 +0000, Seiji Aguchi wrote:
>> A value of efi.runtime_version is checked before calling
>> update_capsule()/query_variable_info() as follows.
>> But it isn't initialized anywhere.
>> <snip>
>> static efi_status_t virt_efi_query_variable_info(u32 attr,
>>                                                  u64 *storage_space,
>>                                                   u64 *remaining_space,
>>                                                  u64 *max_variable_size) {
>>         if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
>>                 return EFI_UNSUPPORTED; 
>> <snip>
>>
>> This patch initializes a value of efi.runtime_version at boot time.
>>
>> Acked-by: Matthew Garrett <mjg@redhat.com>
>> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
>> ---
>>  arch/x86/platform/efi/efi.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> Thanks, I picked this up just so it doesn't get lost. It will probably
> go to Linus via Peter Anvin.
> 

Should I take that as an Acked-by: on your part?

	-hpa


