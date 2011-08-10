Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab1HJPLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:11:52 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59305 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1HJPLv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:11:51 -0400
MIME-Version: 1.0
In-Reply-To: <493994B35A117E4F832F97C4719C4C040132CE88A0@orsmsx505.amr.corp.intel.com>
References: <cover.1312893572.git.luto@mit.edu> <d9f3056c77b6cd44a2f4c90278ce483a011dda12.1312893572.git.luto@mit.edu>
 <493994B35A117E4F832F97C4719C4C040132CE80CE@orsmsx505.amr.corp.intel.com>
 <CAObL_7EozFSbcqJiwV=PNH-3sN0M1QfaTu3i4A_OKsZ0Ue5g7A@mail.gmail.com> <493994B35A117E4F832F97C4719C4C040132CE88A0@orsmsx505.amr.corp.intel.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 10 Aug 2011 11:11:30 -0400
X-Google-Sender-Auth: wUh49FJf73dSBjXMNiNS0FigTWo
Message-ID: <CAObL_7E_2hMPtmgvq8ypKTovH-DKP+4LjRW_McMazJcfr_9Vdg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] x86: Enable fast strings on Intel if BIOS hasn't already
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "Anvin, H Peter" <h.peter.anvin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 11:05 AM, Yu, Fenghua <fenghua.yu@intel.com> wrote:
>> -----Original Message-----
>> From: amluto@gmail.com [mailto:amluto@gmail.com] On Behalf Of Andrew
>> Lutomirski
>> Sent: Wednesday, August 10, 2011 7:50 AM
>> To: Yu, Fenghua
>> Cc: x86@kernel.org; linux-kernel@vger.kernel.org; Matthew Garrett; Len
>> Brown; linux-acpi@vger.kernel.org; Ingo Molnar; Anvin, H Peter
>> Subject: Re: [PATCH v3 1/2] x86: Enable fast strings on Intel if BIOS
>> hasn't already
>>
>> On Tue, Aug 9, 2011 at 11:40 AM, Yu, Fenghua <fenghua.yu@intel.com>
>> wrote:
>> >> -----Original Message-----
>> >> From: Andy Lutomirski [mailto:luto@MIT.EDU]
>> >> Sent: Tuesday, August 09, 2011 5:41 AM
>> >> To: x86@kernel.org; linux-kernel@vger.kernel.org
>> >> Cc: Yu, Fenghua; Matthew Garrett; Len Brown; linux-
>> >> acpi@vger.kernel.org; Ingo Molnar; Andy Lutomirski
>> >> Subject: [PATCH v3 1/2] x86: Enable fast strings on Intel if BIOS
>> >> hasn't already
>> >>
>> >> Intel SDM volume 3A, 8.4.2 says:
>> >>
>> >>   Software can disable fast-string operation by clearing the
>> >>   fast-string-enable bit (bit 0) of IA32_MISC_ENABLE MSR.
>> >>   However, Intel recomments that system software always enable
>> >>   fast-string operation.
>> >>
>> >> The Intel DQ67SW board (with latest BIOS) disables fast string
>> >> operations if TXT is enabled.  A Lenovo X220 disables it regardless
>> >> of TXT setting.  I doubt I'm the only person with a dumb BIOS like
>> >> this.
>> >>
>> >> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> >> ---
>> >>  arch/x86/kernel/cpu/intel.c |   28 +++++++++++++++++++++++-----
>> >>  1 files changed, 23 insertions(+), 5 deletions(-)
>> >
>> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
>> >
>> >
>>
>> Please don't apply.  This patch breaks !CONFIG_SMP.  I'll send a fixed
>> patch later on.
>
> +                               printk_once(KERN_INFO FW_WARN "CPU #%d: IA32_MISC_ENABLE.FAST_STRING_ENABLE was not set",
> There is no need to print CPU id. Then there is no SMP issue.

True, and with the printk_once change it's pointless.  I was printing
it because of the other patch: my BIOS enables monitor/mwait on some,
but not all, CPUs.  (Working around that is a little less optional.
My systems gets lucky because it's off on the boot CPU so the idle
loop doesn't call mwait.  If it were the other way around, the kernel
would presumably oops quickly.)

--Andy
