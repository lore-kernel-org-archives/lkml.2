Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab3ABH0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 02:26:42 -0500
Received: from mga12.intel.com ([143.182.124.36]:5266 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752301Ab3ABH0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 02:26:39 -0500
Message-ID: <1357111592.27261.19.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
From: Matt Fleming <matt.fleming@intel.com>
To: joeyli <jlee@suse.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, Len Brown <lenb@kernel.org>,
        Arjan van de Ven <arjan@infradead.org>
Date: Wed, 02 Jan 2013 07:26:32 +0000
In-Reply-To: <1357094751.6113.253.camel@linux-s257.site>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <50DE03D8.9030902@zytor.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B01921638@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <50DE2EED.9030608@zytor.com> <1357094751.6113.253.camel@linux-s257.site>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-02 at 10:45 +0800, joeyli wrote:
> I didn't find the EFI RTC problem on Asus from google. 
> Could you please share what's the situation on ASUS hardware?

It's mentioned in the following commit (which has since been reverted in
Linus' tree),

commit 185034e72d591f9465e5e18f937ed642e7ea0070
Author: Matt Fleming <matt.fleming@intel.com>
Date:   Fri Sep 7 18:28:04 2012 +0100

    x86, efi: 1:1 pagetable mapping for virtual EFI calls
    
    Some firmware still needs a 1:1 (virt->phys) mapping even after we've
    called SetVirtualAddressMap(). So install the mapping alongside our
    existing kernel mapping whenever we make EFI calls in virtual mode.
    
    This bug was discovered on ASUS machines where the firmware
    implementation of GetTime() accesses the RTC device via physical
    addresses, even though that's bogus per the UEFI spec since we've
    informed the firmware via SetVirtualAddressMap() that the boottime
    memory map is no longer valid.
    
    This bug seems to be present in a lot of consumer devices, so there's
    not a lot we can do about this spec violation apart from workaround
    it.
    

The bug was originally mentioned here,

	https://lkml.org/lkml/2012/3/12/214


