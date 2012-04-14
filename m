Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab2DNVPX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 17:15:23 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59812 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2DNVPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 17:15:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAJyhjX3W6LiTihWC5bRx6ShpKA8JUCSdJ+ry2gDE+=rpF5MytQ@mail.gmail.com>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
	<4F7AB6FE.3080009@silka.with-linux.com>
	<20120403200306.0afbb48b@xenia.leun.net>
	<CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com>
	<CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
	<20120404235104.682cfad3@xenia.leun.net>
	<4F7DE3A4.1040705@candelatech.com>
	<CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com>
	<4F7F52BD.7060906@candelatech.com>
	<20120409010816.36244f17@xenia.leun.net>
	<CAD2nsn3-C8ZLmUpTDeA6HuPr-+=V5KkPJb6h5e7ZJsGi4v9p0g@mail.gmail.com>
	<20120409122549.7469543a@xenia.leun.net>
	<20120409160322.6b7b8c67@xenia.leun.net>
	<CAD2nsn0n-VQ8ZOm69BNrbFv5HK3cdm+22yKrYprwoeFz-E2Uew@mail.gmail.com>
	<20120409172933.4ca4775a@xenia.leun.net>
	<4F86DCB1.20507@openwrt.org>
	<CAMP44s1t+kVdRi_zhR1Qt045KEwco_PQhpa-cC9zMWc5QOFA8Q@mail.gmail.com>
	<20120412173518.2ecd8418@xenia.leun.net>
	<4F871AB8.3070302@openwrt.org>
	<CAJyhjX3W6LiTihWC5bRx6ShpKA8JUCSdJ+ry2gDE+=rpF5MytQ@mail.gmail.com>
Date: Sun, 15 Apr 2012 00:15:19 +0300
Message-ID: <CAMP44s2q=fk8um7uzv-bj1+hq_meSw1_K05Au6XwKKeUrstFYw@mail.gmail.com>
Subject: Re: 3.4-rc ath9k regression (Re: [ath9k-devel] 3.3.1 ath9k regression)
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Sergio Correia <lists@uece.net>
Cc: Felix Fietkau <nbd@openwrt.org>, Michael Leun <ml@elektra.leun.net>,
        Michael Leun <lkml20120218@newton.leun.net>,
        Mohammed Shafi <shafi.wireless@gmail.com>,
        Ben Greear <greearb@candelatech.com>, casteyde.christian@free.fr,
        Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 10:28 PM, Sergio Correia <lists@uece.net> wrote:
> Hello Felix,
>
> On Thu, Apr 12, 2012 at 2:11 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2012-04-12 5:35 PM, Michael Leun wrote:
>>> On Thu, 12 Apr 2012 16:58:34 +0300
>>> Felipe Contreras <felipe.contreras@gmail.com> wrote:
>>>
>>>> On Thu, Apr 12, 2012 at 4:46 PM, Felix Fietkau <nbd@openwrt.org>
>>>> wrote:
>>>> > On 2012-04-09 5:29 PM, Michael Leun wrote:
>>>> >> On Mon, 9 Apr 2012 19:52:45 +0530
>>>>
>>>> >> Seems obvious to me, that this line
>>>> >>
>>>> >> if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
>>>> >>
>>>> >> makes the real difference.
>>>> > Please try this patch with plain 3.3.1 or 3.4-rc2 to see if it fixes
>>>> > this issue:
>>>>
>>>> Nope, not here (3.3.1).
>>>
>>> Also negative for 3.4-rc2, but that SLEEP<>AWAKE noise at the end
>>> stopped. Still need "iwconfig wlan0 essid <myssid>" to make it ping
>>> again (that not included in log below).
>> OK, so my fix is definitely worth submitting, since it gets rid of some
>> unnecessary sleep mode transitions. About the iwconfig command: are you
>> not using wpa_supplicant?
>>
>>> Due to Felipes result and 3.4-rc2 didn't repeat my test with 3.3.1, if
>>> you think it would add useful information I could.
>> Maybe it would be useful to get some more detailed logs from that.
>>
>
> your patch seems to work for me, with 3.3.1:
>
> this is the log after I disable/re-enable the interface:

That is curious, are you saying it doesn't work initially?

Maybe we are talking about two different issues, but my issue is
easily reproducible 100%; I boot, use iwconfig to ad-hoc mode, set the
essid, ip link up, and run wpa_supplicant, at which point it hangs.
It's a strange hang; the rest of the system works fine, but
wpa_supplicant doesn't respond any more and I hear some noise, as if
the CPU was at 100%, but top doesn't show that. With my distro's 3.3.1
kernel I do see the CPU at 100%, although I was trying to connect to
a different (non ad-hoc) network.

It it's helpful I would gladly test different combinations of patches
and networks, just let me know what would you like me to test.

Cheers.

-- 
Felipe Contreras
