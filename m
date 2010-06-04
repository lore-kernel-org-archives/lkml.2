Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab0FDCNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:13:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33529 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab0FDCNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aBcjt1vZ+FJuDgmGJ6+FwpG/Ss0H35Y1DP9dMIX9Rqugc4BIXDRQH1/IBKyGS9Fgyj
         8z5Rx/pgjEwGXvb/QnH5mo/FAiXJrPRx4Aa5qGyiosx1ObWYu9ezWYlvUyIwsOWouU+g
         m69DX2oRi2jqMpluVO0PHqp5nfko3teFkMRsM=
MIME-Version: 1.0
In-Reply-To: <20100603191023.96d74346.akpm@linux-foundation.org>
References: <201006040005.o5405Afw023296@imap1.linux-foundation.org>
	<AANLkTilX_Fbc_pR1jtgQJsvu7RbMfgyhJYCxqV725T18@mail.gmail.com>
	<20100603185401.1851c94e.akpm@linux-foundation.org>
	<AANLkTikDzAHHH62Wti1D-iV7pqa6u24BDgigIYO5JZJR@mail.gmail.com>
	<20100603191023.96d74346.akpm@linux-foundation.org>
Date: Fri, 4 Jun 2010 10:13:52 +0800
Message-ID: <AANLkTik5xtRYSdUGogmBBW2V3t1D42QeTnQrmkMSAXWr@mail.gmail.com>
Subject: Re: mmotm 2010-06-03-16-36 uploaded
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 10:10 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 4 Jun 2010 10:02:57 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> On Fri, Jun 4, 2010 at 9:54 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Fri, 4 Jun 2010 09:41:58 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>> >
>> >> On Fri, Jun 4, 2010 at 7:36 AM, __<akpm@linux-foundation.org> wrote:
>> >> > The mm-of-the-moment snapshot 2010-06-03-16-36 has been uploaded to
>> >> >
>> >> > __ http://userweb.kernel.org/~akpm/mmotm/
>> >> >
>> >>
>> >> Hi, intel_idle build fails:
>> >>
>> >> drivers/idle/intel_idle.c: In function ___intel_idle___:
>> >> drivers/idle/intel_idle.c:234: error: too few arguments to function ___trace_power
>> >> _start___
>> >> make[2]: *** [drivers/idle/intel_idle.o] Error 1
>> >> make[1]: *** [drivers/idle] Error 2
>> >> make[1]: *** Waiting for unfinished jobs....
>> >>
>> >
>> > Caused by
>> > x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent.patch
>> > which changed trace_power_start().
>> >
>> > drivers/idle/intel_idle.c wasn't there when Thomas wrote that patch.
>> >
>> > this, I guess:
>> >
>> > --- a/drivers/idle/intel_idle.c~x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix
>> > +++ a/drivers/idle/intel_idle.c
>> > @@ -231,7 +231,7 @@ static int intel_idle(struct cpuidle_dev
>> >
>> > __ __ __ __stop_critical_timings();
>> > __#ifndef MODULE
>> > - __ __ __ trace_power_start(POWER_CSTATE, (eax >> 4) + 1);
>> > + __ __ __ trace_power_start(POWER_CSTATE, (eax >> 4) + 1, cpu);
>> > __#endif
>> > __ __ __ __if (!need_resched()) {
>> >
>>
>> With one more param "cpu", fails with "too many arguments":
>>
>>   CC      drivers/idle/intel_idle.o
>> drivers/idle/intel_idle.c: In function ___intel_idle___:
>> drivers/idle/intel_idle.c:234: error: too many arguments to function
>> ___trace_power_start___
>> make[2]: *** [drivers/idle/intel_idle.o] Error 1
>> make[1]: *** [drivers/idle] Error 2
>> make[1]: *** Waiting for unfinished jobs....
>
> hm, It Works For Me.  I suspect you applied my patch to mainline, not
> to -mm.
>

oops, you are right, I applied to different tree.

Tested, it works

-- 
Regards
dave
