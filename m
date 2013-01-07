Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab3AGPGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:06:54 -0500
Received: from mout0.freenet.de ([195.4.92.90]:49506 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab3AGPGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:06:52 -0500
Message-ID: <50EAE3E1.4010809@01019freenet.de>
Date: Mon, 07 Jan 2013 16:04:01 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Firefox/17.0 SeaMonkey/2.14
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 104/173] rt2x00: Dont let mac80211 send a BAR when an AMPDU
 subframe fails
References: <20121228190352.097882544@decadent.org.uk>  <50DEA41E.6010409@01019freenet.de>  <1356871099.4821.16.camel@deadeye.wl.decadent.org.uk>  <1356871357.4821.19.camel@deadeye.wl.decadent.org.uk>  <20130107080532.GA2984@redhat.com> <20130107081003.GB2984@redhat.com> <1357568256.26822.18.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1357568256.26822.18.camel@deadeye.wl.decadent.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
> On Mon, 2013-01-07 at 09:10 +0100, Stanislaw Gruszka wrote:
>> On Mon, Jan 07, 2013 at 09:05:32AM +0100, Stanislaw Gruszka wrote:
>>>> To be clear, I have all of these in the queue:
>>>>
>>>> be03d4a45c09 rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails
>>>> 5b632fe85ec8 mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
>>>> ab9d6e4ffe19 Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails"
>>>>
>>>> and I'm intending to drop/defer them all.
>>>
>>> Patch 3 is a revert of patch 1 (questioned patch). Please apply all 3 patches,
>>> or only patch 2.
>>
>> No, actually all 3 patches have to be applied. Because last one, except
>> revert, include flag IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL setting in rt2x00
>> driver, which make patch 2 work.
> 
> Andreas said that that after ab9d6e4ffe19 there was still a regression.
> But maybe he was confused.  I know I'm confused.

:-))

No, the thing is:
rt2800pci misses an appropriate handling of aggregation (which meets the
requirements of mac80211).

Both workarounds, mine and the new workaround from Stanislaw (which is
nothing more than a restricted version of my initial workaround), work
like this:
Let the peer do the aggregation handling. If it's not done by the peer,
the connection will break down.

Therefore:
The solution would be IMHO, to implement an own aggregation handling,
maybe the same way as it was done for carl9170, which had the same problem:

http://thread.gmane.org/gmane.linux.kernel.wireless.general/100793/focus=1405

I prefer to have solutions (if one is known) instead of another workaround.
If I use my device as STA instead of an AP, it even works fine w/o
Stanislaws patch. Do you understand what I'm trying to say?



Thanks,
kind regards,
Andreas
