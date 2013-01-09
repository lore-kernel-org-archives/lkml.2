Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab3AIG2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 01:28:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43098 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab3AIG2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 01:28:10 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1357712591.6113.389.camel@linux-s257.site>
References: <1356712001-12198-1-git-send-email-jlee@suse.com> <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com> <1356742803.6113.245.camel@linux-s257.site> <50DE4259.7090409@zytor.com> <1357712591.6113.389.camel@linux-s257.site>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 08 Jan 2013 22:27:36 -0800
To: joeyli <jlee@suse.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>
Message-ID: <ea4b2055-980b-4f2c-8810-65de479f45ce@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That makes it even less compelling...

joeyli <jlee@suse.com> wrote:

>於 五，2012-12-28 於 17:07 -0800，H. Peter Anvin 提到：
>> On 12/28/2012 05:00 PM, joeyli wrote:
>> > 於 五，2012-12-28 於 17:43 +0000，Matthew Garrett 提到：
>> >> On Sat, 2012-12-29 at 00:26 +0800, Lee, Chun-Yi wrote:
>> >>> UEFI time services, GetTime(), SetTime(), GetWakeupTime(),
>SetWakeupTime() are also
>> >>> supported by other non-IA64 architecutre with UEFI BIOS, e.g.
>x86.
>> >>>
>> >>> This patch changed RTC_DRV_EFI configuration to depend on EFI but
>not just IA64. It
>> >>> checks efi_enabled flag and efi-rtc driver should enabled.
>> >>
>> >> In theory, certainly - but do we still have machines that explode
>if the
>> >> get_time call is made? We may also want to think about disabling
>the
>> >> legacy access to the RTC if the EFI calls are present.
>> > 
>> > The legacy get_time access on my test machine is work fine, not
>thing
>> > explode. :-)
>> > Just we have a function want to expose the timezone information to
>> > userspace and also store it.
>> > 
>> 
>> We should indeed save the timezone information if it is available --
>> either from the ACPI TAD or from the EFI RTC, or even via some
>> platform-dependent mechanism.  It is important, though, that that is
>> separate from the order of priority.
>> 
>> 	-hpa
>> 
>
>I found Windows 8 doesn't aware/maintain the Timezone and Daylight
>fields in EFI_TIME struct.
>
>I got a Acer UEFI notebook and I keep the Windows 8 hard drive
>(/dev/sda) but install Linux to another hard drive (/dev/sdb). 
>
>On Linux, I applied my rtc-efi patches for allow user space feed
>Timezone and store it to BIOS through SetTime(). I wrote a simple user
>space program to set Timezone and Daylight fields, after set those
>fields I reboot to Windows 8 and use DateTime setting GUI to look at
>the
>change. Looks Windows doesn't aware the change, it just assume the time
>in DateTime filed is local time, but didn't show the Timezone that was
>set by me on Linux to GUI.
>
>Then, I select another Timezone(country) through Windows 8 GUI, and
>reboot to Linux. I read the Timezone and Daylight by program but didn't
>see the Timezone and Daylight changed by Windows 8, the value is still
>the same with my latest time setting by Linux program. Windows 8
>changed
>DayTime fields but didn't maintain Timezone and Daylight.
>
>I only have this machine with preloaded Windows 8 for verify the
>behavior, not sure it's normally or not. If Windows 8 ignores Timezone
>and Daylight fields in UEFI BIOS, then I think it's lower down the
>necessary for we maintain Timezone and Daylight in UEFI BIOS. 
>
>We still can store Timezone and Daylight value to UEFI, but will have
>no
>any interactive with Windows 8.
>
>Appreciate for any suggestions.
>
>
>Thanks a lot!
>Joey Lee

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
