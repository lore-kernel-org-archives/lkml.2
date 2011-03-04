Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab1CDMua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:50:30 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47368 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400Ab1CDMu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:50:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZzbjZ4nbxHRTZsgm4CLYtIOLc9VHegmZmxbT7rCy2Gcq33cATIfL8fOrIO6RChnYYA
         fqTmz1ZQd1K4k/Izgw6fvrPpjw4D9bVDB33cRzmsLgFfvqgsInq5o+eZHngsqrZEHNYk
         DbQ1aFVq5qoGzYNxEmCZPshEIcsbjO8c4y4tA=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=zU=N35RYmcSEkoLNAycQy7Cfcq3jHBYu+dq1O@mail.gmail.com>
References: <1299239923-7092-1-git-send-email-henne@nachtwindheim.de>
	<AANLkTi=zU=N35RYmcSEkoLNAycQy7Cfcq3jHBYu+dq1O@mail.gmail.com>
Date: Fri, 4 Mar 2011 15:50:28 +0300
Message-ID: <AANLkTimptB1K3Kc+Hy1JbY=38pHSp0FfjA1LAKniLV2m@mail.gmail.com>
Subject: Re: [PATCHv2 1/7] x86: remove superflous goal definition of tsc_sync
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 3:43 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Fri, Mar 4, 2011 at 2:58 PM, Henrik Kretzschmar
> <henne@nachtwindheim.de> wrote:
>> This goal definition is superflous.
>> CONFIG_X86_64_SMP depends on CONFIG_SMP
>> and tsc_sync.o is already in the definition of CONFIG_SMP.
>>
>> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
>> ---
>>  arch/x86/kernel/Makefile |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
>> index 4ad4509..6b61081 100644
>> --- a/arch/x86/kernel/Makefile
>> +++ b/arch/x86/kernel/Makefile
>> @@ -69,7 +69,6 @@ obj-$(CONFIG_APM)             += apm.o
>>  obj-$(CONFIG_SMP)              += smp.o
>>  obj-$(CONFIG_SMP)              += smpboot.o tsc_sync.o
>>  obj-$(CONFIG_SMP)              += setup_percpu.o
>> -obj-$(CONFIG_X86_64_SMP)       += tsc_sync.o
>>  obj-$(CONFIG_X86_MPPARSE)      += mpparse.o
>>  obj-y                          += apic/
>>  obj-$(CONFIG_X86_REBOOTFIXUPS) += reboot_fixups_32.o
>> --
>> 1.7.2.3
>>
>>
>
> Probably we better write it this way:
>
> - obj-$(CONFIG_SMP)              += smpboot.o tsc_sync.o
> - obj-$(CONFIG_X86_64_SMP)       += tsc_sync.o
>
> + obj-$(CONFIG_SMP)              += smpboot.o
> + obj-$(CONFIG_SMP)              += tsc_sync.o
>
> I guess this would be cleaner? Ingo?
>

Others patches in series looks good to me, feel free to add
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
when needed. Thanks a lot!
