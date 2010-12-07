Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab0LGWhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:37:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab0LGWha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:37:30 -0500
Message-ID: <4CFEB6EB.9070502@redhat.com>
Date: Tue, 07 Dec 2010 20:36:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Arnaud Lacombe <lacombar@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        brueckner@linux.vnet.ibm.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: visibility changes (was: Re: [GIT] kbuild and kconfig fixes for
 2.6.37-rc5)
References: <AANLkTikVM=zakYF7uhX1mYHy9QUVL6dmEPNsmV7=oyuh@mail.gmail.com>	<AANLkTi=iH6QOAph0iW6MR2khD5KCe8mRLPe8Y3QnTTTW@mail.gmail.com>	<AANLkTik2SWrmVJ1o98-e2CwJP9SAo6oMmnuLc4K+rT1R@mail.gmail.com>	<AANLkTikdNXdDoixEzGbirH+U_v62vDeEMGaRRpvTsJpu@mail.gmail.com> <AANLkTin8Xf9SPcHrBPRPg+cnbWO94CwB4u6KQ2it1+Y9@mail.gmail.com>
In-Reply-To: <AANLkTin8Xf9SPcHrBPRPg+cnbWO94CwB4u6KQ2it1+Y9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 07-12-2010 18:45, Geert Uytterhoeven escreveu:
> On Tue, Dec 7, 2010 at 21:40, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> On Tue, Dec 7, 2010 at 3:31 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> On Tue, Dec 7, 2010 at 20:51, Arnaud Lacombe <lacombar@gmail.com> wrote:
>>>> On Tue, Dec 7, 2010 at 2:07 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>>>> On Sat, Dec 4, 2010 at 14:57, Michal Marek <mmarek@suse.cz> wrote:
>>>>>> please pull these kbuild/kconfig fixes for the next -rc. The largest
>>>>>> part are fixes for the annoying kconfig warnings, contributed by Arnaud
>>>>>> Lacombe and Mauro Carvalho Chehab. The solution adds a new 'visible if'
>>>>>> keyword to the Kconfig language, so it's not exactly something that one
>>>>>> would expect in the rc phase, but the kconfig change is not huge (the
>>>>>> large diff is due to generated files) and it is deployed only in those
>>>>>> five Kconfig files that had the warnings and were hard to fix by other
>>>>>> means.  The second part is a forgotten patch by Hendrik Brueckner to
>>>>>> usr/initramfs, that fixes build for Blackfin and h8300.
>>>>>
>>>>>> Arnaud Lacombe (5):
>>>>>>      kconfig: add an option to determine a menu's visibility
>>>>>
>>>>> Hmm, this changeset also went in through the v4l tree?
>>>>>
>>>> Mauro merely imported the set in his tree to give them visibility and
>>>> testing, but they went in trough the kbuild tree after being in -next
>>>> for a week.
>>>
>>> Hmm, git show 86e187ff9bce9fbed7bfed92ae34f491cf1af50f doesn't
>>> show a SoB from Michal...
>>>
>> Why would you expect it to ? Most of the commit in Linus' tree are not
>> personally SoB by him.
> 
> Sorry, you're right.
> 
>>>>> BTW, I got confused:
>>>>>  - make allmodconfig causes e.g.:
>>>>>        CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
>>>>>        CONFIG_VIDEO_TVAUDIO=m
>>>>>    => good
>>>>>  - make oldconfig for my config with almost everything selected,
>>>>> except for stuff I know that breaks:
>>>>>        CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
>>>>>        # CONFIG_VIDEO_TVAUDIO is not set
>>>>>    and no way to manually set CONFIG_VIDEO_TVAUDIO=y?
>>>>>    => bad!
>>>> that's difficult to judge without your old configuration.
>>>> VIDEO_TVAUDIO is only selected by VIDEO_BT848 which you don't give
>>>> information about.
>>>
>>> I don't have PCI, so I cannot enable VIDEO_BT848.
>>>
>> so why do you expect VIDEO_TVAUDIO to be enabled ?
> 
> I don't expect it to be enabled, I expected to be able to enable it.
> Allmodconfig
> does enable it.

Why do you want to enable a device that doesn't work? There's no other driver
but bttv that has upport for the devices implemented by tvaudio module.

/me is confused...

Cheers,
Mauro
