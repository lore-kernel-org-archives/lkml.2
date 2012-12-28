Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2L1Ulf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:41:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38547 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab2L1Ulc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:41:32 -0500
Message-ID: <50DE03D8.9030902@zytor.com>
Date: Fri, 28 Dec 2012 12:40:56 -0800
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
References: <1356712001-12198-1-git-send-email-jlee@suse.com>  <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>  <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com> <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com>
In-Reply-To: <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2012 11:17 AM, Matthew Garrett wrote:
> On Fri, 2012-12-28 at 11:07 -0800, H. Peter Anvin wrote:
>> We do have such machines, which is why this change has been reverted twice already.  I believe we should stick to the priority scheme I proposed a few weeks ago.
>
> I seem to have missed that discussion, and couldn't find it after a
> brief search. Got a pointer?
>

Looks like it was a non-public distribution ... anyway, what I wrote was:

> I suspect that what we *should* do looks like:
>
> 1. If ACPI exports a Time and Alarm Device (ACPI000E) the use it;
> 2. If ACPI exports an PC/AT device (PNP0B00/1/2) then use it(*);
> 3. If we have an EFI RTC use it;
> 4. Probe for a PC/AT RTC device.
>
> I'm unsure what the ordering of 1 & 2 should be.  The ACPI device has
> the advantage that it contains time zone information, which is important
> for Windows interoperability, and at least optionally supports
> millisecond resolution; there is no way to even export "this is where
> you find time zone information" (since we're dealing with an RTC with
> embedded CMOS, there is storage available, it is just a matter of
> telling the OS how to find it) for the PNP0B0x devices.
>
> The TAD is also guaranteed to map 1:1 to the EFI RTC.
>
> 	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

