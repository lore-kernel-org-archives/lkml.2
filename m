Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab0EWNTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 09:19:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36128 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab0EWNTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 09:19:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EghrVmNILX55iHfJawO4MAIZ+bYacBceHlbAw8kT/FN5xIqMFEbgm/0JOab005oakw
         9HoyeKqh+9MRyJ4gSgC8KbQsCNRBJf01NX0EKNljAqoI1GoyG7z50a7rN8OEh3wNzweX
         AZUyvRscNkUbS4x/AnTwPoXKT3od42dmqUZPc=
MIME-Version: 1.0
In-Reply-To: <1274608166.4090.2.camel@jlt3.sipsolutions.net>
References: <AANLkTikg6BEFCC-vwn3K96ZI-uiErg4SO8V701SWNkn0@mail.gmail.com>
	 <1274608166.4090.2.camel@jlt3.sipsolutions.net>
Date: Sun, 23 May 2010 21:19:15 +0800
Message-ID: <AANLkTilWMwhbBAowgorzy9pbYKb1dvws7fTyYf9m1l7i@mail.gmail.com>
Subject: Re: Wireless IBSS on Linux-2.6.34 broken by commit 
	3bbb9ec946428b96657126768f65487a48dd090c
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Frans Pop <elendil@planet.nl>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 2010-05-23 at 05:58 +0100, Jeff Chua wrote:
> Wireless IBSS on Linux-2.6.34 is broken. Reverting commit
> 3bbb9ec946428b96657126768f65487a48dd090c makes it work again. This was
> tested by bisecting the kernel.

On Sun, May 23, 2010 at 2:21 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
> can you get us whole dmesg of two cases?
> (just to know if there's something in surrounding messages of interest)


On Sun, May 23, 2010 at 5:49 PM, Johannes Berg <johannes.berg@intel.com> wrote:
> This is odd -- as Arjan said more logging would be good, if you can
> enable mac80211 IBSS debug (though in one case we had recently that
> _fixed_ the issue unfortunately) -- it's under the mac80211 debug menu
> Kconfig.
>
> FWIW, I don't know about anything in mac80211 that would be timer
> sensitive?

Arjan, Johannes,

Here's the dmesg I see. The only difference between the non-working
and working ones are the last 4 lines below with the bad commit
reverted. With the non-working one, I don't see the last 4 lines no
matter how long I waited.
And I'm guessing it's something to do with mod_timer() that modified
the timer's timeout. mod_timer() is used by by both iwlwifi amd
mac80211. I'll get the full mac80211 debug soon.

2010-05-22T11:42:55.129641+08:00 boston kernel: cfg80211: Calling CRDA
to update world regulatory domain
2010-05-22T11:42:55.162713+08:00 boston kernel: iwlagn: Intel(R)
Wireless WiFi Link AGN driver for Linux, in-tree:
2010-05-22T11:42:55.162782+08:00 boston kernel: iwlagn: Copyright(c)
2003-2010 Intel Corporation
2010-05-22T11:42:55.162785+08:00 boston kernel: iwlagn 0000:02:00.0:
PCI INT A -> GSI 16 (level, low) -> IRQ 16
2010-05-22T11:42:55.162788+08:00 boston kernel: iwlagn 0000:02:00.0:
setting latency timer to 64
2010-05-22T11:42:55.162814+08:00 boston kernel: iwlagn 0000:02:00.0:
Detected Intel Wireless WiFi Link 6000 Series 2x2 AGN REV=0x74
2010-05-22T11:42:55.182139+08:00 boston kernel: iwlagn 0000:02:00.0:
Tunable channels: 13 802.11bg, 24 802.11a channels
2010-05-22T11:42:55.182164+08:00 boston kernel: iwlagn 0000:02:00.0:
irq 44 for MSI/MSI-X
2010-05-22T11:42:55.182169+08:00 boston kernel: iwlagn 0000:02:00.0:
firmware: requesting iwlwifi-6000-4.ucode
2010-05-22T11:42:55.198654+08:00 boston kernel: iwlagn 0000:02:00.0:
loaded firmware version 9.193.4.1
2010-05-22T11:42:55.201637+08:00 boston kernel: phy0: Selected rate
control algorithm 'iwl-agn-rs'
2010-05-22T11:42:57.538644+08:00 boston kernel: wlan0: Trigger new
scan to find an IBSS to join

(*** These shows up for the working kernel with bad commit removed ***)
2010-05-22T11:43:04.797649+08:00 boston kernel: wlan0: Trigger new
scan to find an IBSS to join
2010-05-22T11:43:08.149646+08:00 boston kernel: wlan0: Creating new
IBSS network, BSSID 46:9a:67:c7:5d:30
2010-05-22T11:43:08.207216+08:00 boston kernel: iwlagn 0000:02:00.0:
Unable to find TIM Element in beacon
2010-05-22T11:43:08.207232+08:00 boston kernel: iwlagn 0000:02:00.0:
Unable to find TIM Element in beacon


Thanks,
Jeff.
