Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab1IBCVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 22:21:21 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36535 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab1IBCVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 22:21:17 -0400
MIME-Version: 1.0
In-Reply-To: <1314927625.3058.53.camel@localhost.localdomain>
References: <20110822145304.980529cb921e5f1321c622da@canb.auug.org.au>
	<20110822125355.bb01d76b.rdunlap@xenotime.net>
	<CACqU3MVjg60pTPyNWm+41w144QzPgtHQ4wZPUUV=vok8gGffuQ@mail.gmail.com>
	<20110822174958.73dd96c7.rdunlap@xenotime.net>
	<1314065358.3225.44.camel@localhost.localdomain>
	<20110823164035.ca28fdc6.rdunlap@xenotime.net>
	<CACqU3MWfKji5BcGRmwO_Y4_15oOq7Trw3u6j1g2meFAaG-s9-w@mail.gmail.com>
	<1314362342.3224.19.camel@localhost.localdomain>
	<20110826100011.9213d872.rdunlap@xenotime.net>
	<CACqU3MXBjHi9nOfxeQGJVtc7x33KbzK2Mi+_+A+jr+bPwqzY-Q@mail.gmail.com>
	<CACqU3MWcBJuXA3n=ha_MNteM6MHfEWj8=42nZ_zvorvt6Pbq-w@mail.gmail.com>
	<1314927625.3058.53.camel@localhost.localdomain>
Date: Thu, 1 Sep 2011 22:21:16 -0400
Message-ID: <CACqU3MWf=4Lk1kji3T9V9TZL7p3FzFygTz-ZH3mcb6Y0SSFF0A@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 22 (evm)
From: Arnaud Lacombe <lacombar@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Mimi Zohar <zohar@us.ibm.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 1, 2011 at 9:40 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Thu, 2011-09-01 at 20:32 -0400, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Sat, Aug 27, 2011 at 2:06 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> > Hi,
>> >
>> > On Fri, Aug 26, 2011 at 1:00 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> >> On Fri, 26 Aug 2011 08:39:02 -0400 Mimi Zohar wrote:
>> >>
>> >>> On Tue, 2011-08-23 at 22:10 -0400, Arnaud Lacombe wrote:
>> >>> > Hi,
>> >>> >
>> >>> > On Tue, Aug 23, 2011 at 7:40 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> >>> > > I think that you are going to need to do something like Arnaud suggested
>> >>> > > and use "depends on TCG_TPM=y" instead of just "depends on TCG_TPM",
>> >>> > > unless you can convince someone that this is a kconfig bug.
>> >>> > >
>> >>> > dammit... I guess there is...
>> >>> >
>> >>> > If you consider the following Kconfig:
>> >>> >
>> >>> > config MOD
>> >>> >         bool
>> >>> >         default y
>> >>> >         option modules
>> >>> >
>> >>> > config EXPERIMENTAL
>> >>> >         bool
>> >>> >         default y
>> >>> >
>> >>> > menuconfig A
>> >>> >         tristate "A"
>> >>> >         depends on EXPERIMENTAL
>> >>> >
>> >>> > config B
>> >>> >         bool "B"
>> >>> >
>> >>> > config B0
>> >>> >         bool
>> >>> >
>> >>> > config C
>> >>> >         tristate "C"
>> >>> >         depends on B
>> >>> >
>> >>> > config C0
>> >>> >         tristate
>> >>> >
>> >>> > config D
>> >>> >         boolean "D"
>> >>> >         depends on A && B
>> >>> >         select C
>> >>> >         select C0
>> >>> >
>> >>> > config E
>> >>> >         tristate "E"
>> >>> >
>> >>> > config F
>> >>> >         tristate "F"
>> >>> >         select E
>> >>> >
>> >>> > B (KEYS) allows to set C (TRUSTED_KEYS). Also, B (KEYS) and A
>> >>> > (TCG_TPM) allows to set D (EVM), which will select (C). Now,
>> >>> > menuconfig highlight the problem very well. Proceeding as following
>> >>> > A=m, B=y, C=m, E=y, F=y, we ends up having:
>> >>> >
>> >>> >  <M> A  --->
>> >>> >  [*] B
>> >>> >  {M} C
>> >>> >  [*] D
>> >>> >  -*- E
>> >>> >  <*> F
>> >>> >
>> >>> > which translate in the following config:
>> >>> >
>> >>> > CONFIG_MOD=y
>> >>> > CONFIG_EXPERIMENTAL=y
>> >>> > CONFIG_A=m
>> >>> > CONFIG_B=y
>> >>> > CONFIG_C=m
>> >>> > CONFIG_C0=m
>> >>> > CONFIG_D=y
>> >>> > CONFIG_E=y
>> >>> > CONFIG_F=y
>> >>> >
>> >>> > I would have expected CONFIG_C and CONFIG_C0 to be 'y', just as 'E'.
>> >>> > If you remove D's dependency on 'A', everything works as expected. So
>> >>> > it would seem direct dependency state influence the state of reverse
>> >>> > dependencies...
>> >>> >
>> >>> > Will have a look...
>> >>> >
>> >>> >  - Arnaud
>> >>>
>> >>> Thanks for looking into this!  Instead of changing 'TCG_TPM' to
>> >>> 'TCG_TPM=y', the dependency should be on 'TRUSTED_KEYS=y'.  Then when
>> >>> I've refactored ENCRYPTED_KEYS, removing the ENCRYPTED_KEYS dependency
>> >>> on TRUSTED_KEYS, the EVM dependency would be '(TRUSTED_KEYS=y ||
>> >>> TRUSTED_KEYS=n)'.  Do you want a temporary fix for now?
>> >>
>> >> Yes, linux-next (randconfig) builds are still failing, so we need something
>> >> to prevent that.
>> >>
>> > you may want to try:
>> >
>> > git://github.com/lacombar/linux-2.6.git master/kconfig/expr-woes
>> >
>> ping ?
>>
>>  - Arnaud
>
> I assume you want me to test using expr-woes, but I'm not how.  Could
> you help me here a bit.
>
> (Over the weekend I removed encrypted keys dependency on TCG_TPM.)
>
Well, at this point, this is not really related to the particular
issue, but to kconfig more generally. I guess I'll just post the
patches on LKML and see if they triggers non-wanted regression.

Thanks,
 - Arnaud

> thanks,
>
> Mimi
>
>> > only the last commit is relevant to the problem, but depend on one
>> > another to get <assert.h>. The rest aims at tidying the expr stuff.
>> > I'm looking for regression it may have introduced.
>> >
>> > Thanks,
>> >  - Arnaud
>> >
>> > ps: I'll most likely be AFK until sunday evening (to be conservative).
>> >
>> >> thanks,
>> >> ---
>> >> ~Randy
>> >> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>> >>
>> >
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
