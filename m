Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab2L1XpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 18:45:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39585 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab2L1XpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 18:45:15 -0500
Message-ID: <50DE2EED.9030608@zytor.com>
Date: Fri, 28 Dec 2012 15:44:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Lee, Chun-Yi" <jlee@suse.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
References: <1356712001-12198-1-git-send-email-jlee@suse.com>   <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>   <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com>  <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com>  <50DE03D8.9030902@zytor.com> <E99CBA9F97C3D149AA6B19ED2E277C9B01921638@BY2PRD0510MB365.namprd05.prod.outlook.com>
In-Reply-To: <E99CBA9F97C3D149AA6B19ED2E277C9B01921638@BY2PRD0510MB365.namprd05.prod.outlook.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2012 12:49 PM, Matthew Garrett wrote:
> On Fri, 2012-12-28 at 12:40 -0800, H. Peter Anvin wrote:
> 
>>> I suspect that what we *should* do looks like:
>>>
>>> 1. If ACPI exports a Time and Alarm Device (ACPI000E) the use it;
>>> 2. If ACPI exports an PC/AT device (PNP0B00/1/2) then use it(*);
>>> 3. If we have an EFI RTC use it;
>>> 4. Probe for a PC/AT RTC device.
> 
> In terms of ordering, 3 should probably come before 2 - but that depends
> on us actually fixing the issues that are preventing some of these calls
> from working. As far as wallclock time goes, EFI is going to be
> available to us before we've parsed the DSDT to determine whether
> there's any ACPI devices, so we'll almost certainly end up having to use
> it at at least some point during boot. Otherwise, agreed.
> 

[Resending due to misconfigured tablet]

3 before 2 is exactly what is known to break on existing hardware (ASUS).

If anything, we should move to using the EFI RTC as a very last resort,
i.e. 3 after 4.  Ideally we should match Win8 behavior, but that would
require someone mocking up different ACPI and EFI functions in a
simulator and see how Win8 prioritizes things.

	-hpa

