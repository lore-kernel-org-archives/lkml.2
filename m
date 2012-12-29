Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab2L2BIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 20:08:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40054 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755077Ab2L2BIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 20:08:07 -0500
Message-ID: <50DE4259.7090409@zytor.com>
Date: Fri, 28 Dec 2012 17:07:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
References: <1356712001-12198-1-git-send-email-jlee@suse.com>  <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com> <1356742803.6113.245.camel@linux-s257.site>
In-Reply-To: <1356742803.6113.245.camel@linux-s257.site>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2012 05:00 PM, joeyli wrote:
> 於 五，2012-12-28 於 17:43 +0000，Matthew Garrett 提到：
>> On Sat, 2012-12-29 at 00:26 +0800, Lee, Chun-Yi wrote:
>>> UEFI time services, GetTime(), SetTime(), GetWakeupTime(), SetWakeupTime() are also
>>> supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.
>>>
>>> This patch changed RTC_DRV_EFI configuration to depend on EFI but not just IA64. It
>>> checks efi_enabled flag and efi-rtc driver should enabled.
>>
>> In theory, certainly - but do we still have machines that explode if the
>> get_time call is made? We may also want to think about disabling the
>> legacy access to the RTC if the EFI calls are present.
> 
> The legacy get_time access on my test machine is work fine, not thing
> explode. :-)
> Just we have a function want to expose the timezone information to
> userspace and also store it.
> 

We should indeed save the timezone information if it is available --
either from the ACPI TAD or from the EFI RTC, or even via some
platform-dependent mechanism.  It is important, though, that that is
separate from the order of priority.

	-hpa

