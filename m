Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab0EWJtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 05:49:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:43818 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab0EWJtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 05:49:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,285,1272870000"; 
   d="scan'208";a="801071827"
Subject: Re: Wireless IBSS on Linux-2.6.34 broken by commit
 3bbb9ec946428b96657126768f65487a48dd090c
From: Johannes Berg <johannes.berg@intel.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
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
In-Reply-To: <AANLkTikg6BEFCC-vwn3K96ZI-uiErg4SO8V701SWNkn0@mail.gmail.com>
References: <AANLkTikg6BEFCC-vwn3K96ZI-uiErg4SO8V701SWNkn0@mail.gmail.com>
Date: Sun, 23 May 2010 11:49:26 +0200
Message-ID: <1274608166.4090.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4N9nsaS018770

On Sun, 2010-05-23 at 05:58 +0100, Jeff Chua wrote:> Wireless IBSS on Linux-2.6.34 is broken. Reverting commit> 3bbb9ec946428b96657126768f65487a48dd090c makes it work again. This was> tested by bisecting the kernel.> > I'm using 6200 AGN ...> > cfg80211: Calling CRDA to update world regulatory domain> iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:> iwlagn: Copyright(c) 2003-2010 Intel Corporation> iwlagn 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16> iwlagn 0000:02:00.0: setting latency timer to 64> iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74> iwlagn 0000:02:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels> iwlagn 0000:02:00.0: irq 46 for MSI/MSI-X> iwlagn 0000:02:00.0: loaded firmware version 9.193.4.1 build 19710> > > > So, where should the fix be?> > > Here's the commit ...> > 3bbb9ec946428b96657126768f65487a48dd090c is the first bad commit> commit 3bbb9ec946428b96657126768f65487a48dd090c> Author: Arjan van de Ven <arjan@linux.intel.com>> Date:   Thu Mar 11 14:04:36 2010 -0800> >     timers: Introduce the concept of timer slack for legacy timers
This is odd -- as Arjan said more logging would be good, if you canenable mac80211 IBSS debug (though in one case we had recently that_fixed_ the issue unfortunately) -- it's under the mac80211 debug menuKconfig.
FWIW, I don't know about anything in mac80211 that would be timersensitive?
johannes
---------------------------------------------------------------------Intel GmbHDornacher Strasse 185622 Feldkirchen/Muenchen GermanySitz der Gesellschaft: Feldkirchen bei MuenchenGeschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes SchwadererRegistergericht: Muenchen HRB 47456 Ust.-IdNr.VAT Registration No.: DE129385895Citibank Frankfurt (BLZ 502 109 00) 600119052
This e-mail and any attachments may contain confidential material forthe sole use of the intended recipient(s). Any review or distributionby others is strictly prohibited. If you are not the intendedrecipient, please contact the sender and delete all copies.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
