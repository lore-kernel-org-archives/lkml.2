Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab0FDCDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 22:03:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55365 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab0FDCC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 22:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BIEUImwUC0cO71VwLxPmaWNFRsdgsZPi9wnk/pDA8V5uX+qLxY2D2EcuI4O3VAs1vy
         I5I59U5GEyTpjDCL+5QOm0lNPipSfr0DbBc/Ayp/DS7kW6dUotRKULCR8/JXfscVlRgS
         kihm5aZ6Lj3RdDIry7GQbRLdYfzDMJfzPKcbo=
MIME-Version: 1.0
In-Reply-To: <20100603185401.1851c94e.akpm@linux-foundation.org>
References: <201006040005.o5405Afw023296@imap1.linux-foundation.org>
	<AANLkTilX_Fbc_pR1jtgQJsvu7RbMfgyhJYCxqV725T18@mail.gmail.com>
	<20100603185401.1851c94e.akpm@linux-foundation.org>
Date: Fri, 4 Jun 2010 10:02:57 +0800
Message-ID: <AANLkTikDzAHHH62Wti1D-iV7pqa6u24BDgigIYO5JZJR@mail.gmail.com>
Subject: Re: mmotm 2010-06-03-16-36 uploaded
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 9:54 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 4 Jun 2010 09:41:58 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> On Fri, Jun 4, 2010 at 7:36 AM,  <akpm@linux-foundation.org> wrote:
>> > The mm-of-the-moment snapshot 2010-06-03-16-36 has been uploaded to
>> >
>> > __ http://userweb.kernel.org/~akpm/mmotm/
>> >
>>
>> Hi, intel_idle build fails:
>>
>> drivers/idle/intel_idle.c: In function ___intel_idle___:
>> drivers/idle/intel_idle.c:234: error: too few arguments to function ___trace_power
>> _start___
>> make[2]: *** [drivers/idle/intel_idle.o] Error 1
>> make[1]: *** [drivers/idle] Error 2
>> make[1]: *** Waiting for unfinished jobs....
>>
>
> Caused by
> x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent.patch
> which changed trace_power_start().
>
> drivers/idle/intel_idle.c wasn't there when Thomas wrote that patch.
>
> this, I guess:
>
> --- a/drivers/idle/intel_idle.c~x86-cpufreq-make-trace_power_frequency-cpufreq-driver-independent-fix
> +++ a/drivers/idle/intel_idle.c
> @@ -231,7 +231,7 @@ static int intel_idle(struct cpuidle_dev
>
>        stop_critical_timings();
>  #ifndef MODULE
> -       trace_power_start(POWER_CSTATE, (eax >> 4) + 1);
> +       trace_power_start(POWER_CSTATE, (eax >> 4) + 1, cpu);
>  #endif
>        if (!need_resched()) {
>

With one more param "cpu", fails with "too many arguments":

  CC      drivers/idle/intel_idle.o
drivers/idle/intel_idle.c: In function ‘intel_idle’:
drivers/idle/intel_idle.c:234: error: too many arguments to function
‘trace_power_start’
make[2]: *** [drivers/idle/intel_idle.o] Error 1
make[1]: *** [drivers/idle] Error 2
make[1]: *** Waiting for unfinished jobs....

> _
>
>
> it's a bit odd that all trace_power_start() callers just pass in
> smp_processor_id().  Why not do it within trace_power_start() itself?
>
>
>



-- 
Regards
dave
