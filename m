Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3AGSlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:41:08 -0500
Received: from mout2.freenet.de ([195.4.92.92]:48275 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523Ab3AGSlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:41:07 -0500
Message-ID: <50EB162B.7020903@01019freenet.de>
Date: Mon, 07 Jan 2013 19:38:35 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Firefox/17.0 SeaMonkey/2.14
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Andreas Hartmann <andihartmann@01019freenet.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 104/173] rt2x00: Dont let mac80211 send a BAR when an AMPDU
 subframe fails
References: <20121228190352.097882544@decadent.org.uk> <50DEA41E.6010409@01019freenet.de> <1356871099.4821.16.camel@deadeye.wl.decadent.org.uk> <1356871357.4821.19.camel@deadeye.wl.decadent.org.uk> <20130107080532.GA2984@redhat.com> <20130107081003.GB2984@redhat.com> <1357568256.26822.18.camel@deadeye.wl.decadent.org.uk> <50EAE3E1.4010809@01019freenet.de> <20130107165458.GA16705@redhat.com>
In-Reply-To: <20130107165458.GA16705@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw Gruszka wrote:
> On Mon, Jan 07, 2013 at 04:04:01PM +0100, Andreas Hartmann wrote:
>> Ben Hutchings wrote:
>>> On Mon, 2013-01-07 at 09:10 +0100, Stanislaw Gruszka wrote:
>>>> On Mon, Jan 07, 2013 at 09:05:32AM +0100, Stanislaw Gruszka wrote:
>>>>>> To be clear, I have all of these in the queue:
>>>>>>
>>>>>> be03d4a45c09 rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails
>>>>>> 5b632fe85ec8 mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
>>>>>> ab9d6e4ffe19 Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails"
>>>>>>
>>>>>> and I'm intending to drop/defer them all.
>>>>>
>>>>> Patch 3 is a revert of patch 1 (questioned patch). Please apply all 3 patches,
>>>>> or only patch 2.
>>>>
>>>> No, actually all 3 patches have to be applied. Because last one, except
>>>> revert, include flag IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL setting in rt2x00
>>>> driver, which make patch 2 work.
>>>
>>> Andreas said that that after ab9d6e4ffe19 there was still a regression.
> 
> That's not true. There will be no regression after ab9d6e4ffe20. The
> only thing is that solution is not perfect. But perfect solution require
> lot of changes i.e. is not -stable appropriate (and does not exist currently).
> 
>>> But maybe he was confused.  I know I'm confused.
>> :-))
>>
>> No, the thing is:
>> rt2800pci misses an appropriate handling of aggregation (which meets the
>> requirements of mac80211).
>>
>> Both workarounds, mine and the new workaround from Stanislaw (which is
>> nothing more than a restricted version of my initial workaround), work
> 
> Your workaround broke STA mode on some environment.

Why are you sure, that this workaround doesn't break some other devices
running in AP mode? We believed at that time too, it wouldn't harm even
STA. But this was wrong for some (which?) devices.


Anyway: As Helmut meanwhile mentioned that he thankfully works on a
solution now, I'm fine with the second round of workaround.



Kind regards,
Andreas
