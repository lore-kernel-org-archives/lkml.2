Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab2HQKb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:31:58 -0400
Received: from mga12.intel.com ([143.182.124.36]:20328 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757477Ab2HQKbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:31:55 -0400
Subject: Re: [RESEND][PATCH]efi: initialize efi.runtime_version to make
 query_variable_info/update_capsule workable
From: Matt Fleming <matt.fleming@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
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
In-Reply-To: <502D6982.4090100@linux.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB5C7C3@USINDEM103.corp.hds.com>
	 <1345103598.3088.14.camel@mfleming-mobl1.ger.corp.intel.com>
	 <502D6982.4090100@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Fri, 17 Aug 2012 11:31:33 +0100
Message-ID: <1345199493.3088.24.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 14:43 -0700, H. Peter Anvin wrote:
> On 08/16/2012 12:53 AM, Matt Fleming wrote:
> > On Mon, 2012-08-06 at 18:37 +0000, Seiji Aguchi wrote:
> >> A value of efi.runtime_version is checked before calling
> >> update_capsule()/query_variable_info() as follows.
> >> But it isn't initialized anywhere.
> >> <snip>
> >> static efi_status_t virt_efi_query_variable_info(u32 attr,
> >>                                                  u64 *storage_space,
> >>                                                   u64 *remaining_space,
> >>                                                  u64 *max_variable_size) {
> >>         if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
> >>                 return EFI_UNSUPPORTED; 
> >> <snip>
> >>
> >> This patch initializes a value of efi.runtime_version at boot time.
> >>
> >> Acked-by: Matthew Garrett <mjg@redhat.com>
> >> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> >> ---
> >>  arch/x86/platform/efi/efi.c |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > Thanks, I picked this up just so it doesn't get lost. It will probably
> > go to Linus via Peter Anvin.
> > 
> 
> Should I take that as an Acked-by: on your part?

Yep.



