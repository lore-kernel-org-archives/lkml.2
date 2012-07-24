Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab2GXQeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 12:34:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33260 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab2GXQen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 12:34:43 -0400
Date: Tue, 24 Jul 2012 17:34:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "H. Peter Anvin (hpa@linux.intel.com)" <hpa@linux.intel.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "Paul Gortmaker (paul.gortmaker@windriver.com)" 
	<paul.gortmaker@windriver.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH]efi: initialize efi.runtime_version to make
 query_variable_info/update_capsule workable
Message-ID: <20120724163426.GA20961@srcf.ucam.org>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2ED8D@USINDEM101.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2ED8D@USINDEM101.corp.hds.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 01:27:23PM +0000, Seiji Aguchi wrote:
> A value of efi.runtime_version is checked before calling 
> update_capsule()/query_variable_info() as follows.
> But it isn't initialized anywhere.
> 
> <snip>
> static efi_status_t virt_efi_query_variable_info(u32 attr,
>                                                  u64 *storage_space,
>                                                  u64 *remaining_space,
>                                                  u64 *max_variable_size)
> {
>         if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
>                 return EFI_UNSUPPORTED;
> <snip>
> 
> This patch initializes a value of efi.runtime_version at boot time.
> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>

I could have sworn that something equivalent had been posted before, 
but:

Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
