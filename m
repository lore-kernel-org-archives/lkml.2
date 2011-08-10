Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab1HJOuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:50:00 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54181 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1HJOt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:49:58 -0400
MIME-Version: 1.0
In-Reply-To: <493994B35A117E4F832F97C4719C4C040132CE80CE@orsmsx505.amr.corp.intel.com>
References: <cover.1312893572.git.luto@mit.edu> <d9f3056c77b6cd44a2f4c90278ce483a011dda12.1312893572.git.luto@mit.edu>
 <493994B35A117E4F832F97C4719C4C040132CE80CE@orsmsx505.amr.corp.intel.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 10 Aug 2011 10:49:38 -0400
X-Google-Sender-Auth: VJXN3cFqJjE8aZDAmBPQQ2yEFmU
Message-ID: <CAObL_7EozFSbcqJiwV=PNH-3sN0M1QfaTu3i4A_OKsZ0Ue5g7A@mail.gmail.com>
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

On Tue, Aug 9, 2011 at 11:40 AM, Yu, Fenghua <fenghua.yu@intel.com> wrote:
>> -----Original Message-----
>> From: Andy Lutomirski [mailto:luto@MIT.EDU]
>> Sent: Tuesday, August 09, 2011 5:41 AM
>> To: x86@kernel.org; linux-kernel@vger.kernel.org
>> Cc: Yu, Fenghua; Matthew Garrett; Len Brown; linux-
>> acpi@vger.kernel.org; Ingo Molnar; Andy Lutomirski
>> Subject: [PATCH v3 1/2] x86: Enable fast strings on Intel if BIOS
>> hasn't already
>>
>> Intel SDM volume 3A, 8.4.2 says:
>>
>>   Software can disable fast-string operation by clearing the
>>   fast-string-enable bit (bit 0) of IA32_MISC_ENABLE MSR.
>>   However, Intel recomments that system software always enable
>>   fast-string operation.
>>
>> The Intel DQ67SW board (with latest BIOS) disables fast string
>> operations if TXT is enabled.  A Lenovo X220 disables it regardless
>> of TXT setting.  I doubt I'm the only person with a dumb BIOS like
>> this.
>>
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> ---
>>  arch/x86/kernel/cpu/intel.c |   28 +++++++++++++++++++++++-----
>>  1 files changed, 23 insertions(+), 5 deletions(-)
>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
>
>

Please don't apply.  This patch breaks !CONFIG_SMP.  I'll send a fixed
patch later on.

--Andy
