Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab0EZCur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 22:50:47 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:29091 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933557Ab0EZCup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 22:50:45 -0400
Message-ID: <4BFC8C77.7020802@athenacr.com>
Date: Tue, 25 May 2010 22:50:31 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com>	 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>	 <1274727116.2954.5.camel@localhost.localdomain>	 <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain>	 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>	 <4BFB2902.50308@athenacr.com>  <4BFC687A.9040304@athenacr.com> <1274834888.4678.66.camel@localhost.localdomain>
In-Reply-To: <1274834888.4678.66.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:
> On Tue, 2010-05-25 at 20:16 -0400, Brian Bloniarz wrote:
>> On 05/24/2010 09:33 PM, Brian Bloniarz wrote:
>>> So what's wrong with just adding a
>>> /sys/devices/system/clocksource/clocksource0/tsc_khz?
>> As an RFC:
>>
>> Add clocksource.sys_register & sys_unregister so the
>> current clocksource can add supplemental information to
>> /sys/devices/system/clocksource/clocksource0/
>>
>> Export tsc_khz when current_clocksource==tsc so that
>> daemons like NTP can account for the variability of
>> calibration results.
> 
> I think this is a bad idea, as it creates an ABI that is arch AND
> machine specific, which will cause portability problems in applications
> that expect the interface to be there.

It's an arch-independent ABI that returns ENOENT on
unsupported platforms ;)

Could you please explain what you envision as an
arch-independent solution to this problem?
I guess the tsc_long_calibration=1 alternative is
one.
