Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab2DIIpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 04:45:42 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56297 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2DIIpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 04:45:40 -0400
MIME-Version: 1.0
X-Originating-IP: [69.196.158.137]
In-Reply-To: <CAD2nsn3-C8ZLmUpTDeA6HuPr-+=V5KkPJb6h5e7ZJsGi4v9p0g@mail.gmail.com>
References: <4F7A8EB7.4060200@silka.with-linux.com> <4F7A923D.5000002@candelatech.com>
 <CAD2nsn0vKPEOFp08WGYAGh0vEHPbShP4yMo5HzEGc8SrTmTZmQ@mail.gmail.com>
 <4F7A9D5C.8040402@silka.with-linux.com> <CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
 <4F7AAAD9.2040307@silka.with-linux.com> <CAD2nsn0G8_vDQug-u=4PRWMwRLPX-zp1z0X5gOVNaxk=V+daWw@mail.gmail.com>
 <CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
 <4F7AB6FE.3080009@silka.with-linux.com> <20120403200306.0afbb48b@xenia.leun.net>
 <CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com>
 <CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
 <20120404235104.682cfad3@xenia.leun.net> <4F7DE3A4.1040705@candelatech.com>
 <CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com>
 <4F7F52BD.7060906@candelatech.com> <20120409010816.36244f17@xenia.leun.net> <CAD2nsn3-C8ZLmUpTDeA6HuPr-+=V5KkPJb6h5e7ZJsGi4v9p0g@mail.gmail.com>
From: Sergio Correia <lists@uece.net>
Date: Mon, 9 Apr 2012 04:45:19 -0400
Message-ID: <CAJyhjX0jCjRyorUYEf=FXzo=AfjMy3anONSdnZctFWfQ0J1NUQ@mail.gmail.com>
Subject: Re: 3.4-rc ath9k regression (Re: [ath9k-devel] 3.3.1 ath9k regression)
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Michael Leun <lkml20120218@newton.leun.net>,
        Ben Greear <greearb@candelatech.com>, casteyde.christian@free.fr,
        Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mohammed,

On Mon, Apr 9, 2012 at 2:28 AM, Mohammed Shafi <shafi.wireless@gmail.com> wrote:
> On Mon, Apr 9, 2012 at 4:38 AM, Michael Leun
> <lkml20120218@newton.leun.net> wrote:
>> After an suspend to disk / resume cycle (in kernel suspend to disk,
>> openSuSE) with 3.4-rc2 my ath9k wireless does not ping
>> anymore.
>>
>> Output of iwconfig wlan0 looks just as usual (associated to AP).
>>
>> iwconfig wlan0 essid <myssid> fixes this (causes an
>> deauthenticate/authenticate with AP) - then connectivity is there again.
>>
>> Guess what: "Of course" does not happen when reverting
>> c1afdaff90538ef085b756454f12b29575411214 ath9k: fix going to full-sleep
>> on PS idle.
>>
>> So, in my opinion it should be seriously considered to revert that patch
>> until it is fully understood what is going on and why.
>
> please try with the attached patch to see if it helps.
>

with your patch applied on a 3.3 kernel, nothing seems to change here
(AR9285 PCI express): if the card goes through the suspend/resume
cycle, or if I disable/re-enabled the wireless networking on the
network manager, I get the following messages:

[   62.931045] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   65.770425] wlan0: authenticate with 00:26:44:68:e0:6f (try 1)
[   65.967949] wlan0: authenticate with 00:26:44:68:e0:6f (try 2)
[   66.167722] wlan0: authenticate with 00:26:44:68:e0:6f (try 3)
[   66.367504] wlan0: authentication with 00:26:44:68:e0:6f timed out

if I unload/reload the ath9k module, it works again, though:

[   88.657560] ath9k: Driver unloaded
[   88.714713] ath: EEPROM regdomain: 0x60
[   88.714715] ath: EEPROM indicates we should expect a direct regpair map
[   88.714718] ath: Country alpha2 being used: 00
[   88.714720] ath: Regpair used: 0x60
[   88.716415] ieee80211 phy1: Selected rate control algorithm
'ath9k_rate_control'
[   88.716933] Registered led device: ath9k-phy1
[   88.716948] ieee80211 phy1: Atheros AR9285 Rev:2
mem=0xffffc90005960000, irq=17
[   88.735253] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   91.568727] wlan0: authenticate with 00:26:44:68:e0:6f (try 1)
[   91.572181] wlan0: authenticated
[   91.593796] wlan0: associate with 00:26:44:68:e0:6f (try 1)
[   91.598115] wlan0: RX AssocResp from 00:26:44:68:e0:6f (capab=0x411
status=0 aid=2)
[   91.598119] wlan0: associated
[   91.598122] wlan0: moving STA 00:26:44:68:e0:6f to state 1
[   91.598124] wlan0: moving STA 00:26:44:68:e0:6f to state 2
[   91.598775] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   91.611432] wlan0: moving STA 00:26:44:68:e0:6f to state 3

thanks,
sergio

>>
>> It may look theoretically correct (I've no knowledge that would enable
>> me assess that), but it seems to have caused 3 more or less different
>> problems to various people.
>>
>> --
>> MfG,
>>
>> Michael Leun
>>
>
>
>
> --
> thanks,
> shafi
