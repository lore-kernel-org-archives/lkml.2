Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032309Ab2CQALL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 20:11:11 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:52058 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031820Ab2CQALI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 20:11:08 -0400
Date: Sat, 17 Mar 2012 09:11:05 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: iwlagn in linux-next
Message-ID: <20120317001105.GB22560@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

based on a suggestion of Emmanuel, I have now tried linux-next
to see how it improve on iwlagn hanging. (long threads)

Here are some results, based on 3.3.0-rc7-next-20120315

Genereal impression: much more stable, with some hiccups.

Details: After some suspend to ram and resume cycles it is getting 
a bit bad again, with many of that (that is at the university network):
[ 6169.024075] tx session timer expired on tid 0
[ 6169.024124] Tx BA session stop requested for 00:24:c4:ab:bd:ef tid 0
[ 6169.044472] Stopping Tx BA session for 00:24:c4:ab:bd:ef tid 0
[ 6170.930940] Open BA session requested for 00:24:c4:ab:bd:ef tid 0
[ 6170.948299] activated addBA response timer on tid 0
[ 6170.948877] switched off addBA timer for tid 0
[ 6170.948883] Aggregation is on for tid 0

BUT: At least it resettles without connection breaking down completely.
That is a *big* step forward!

On the home network I see many of 
[18392.488123] ieee80211 phy0: release an RX reorder frame due to timeout on earlier frames
but with some intermittend slow-downs it is working.

In both cases an ssh session to a remote computer did *not* break down,
which was permanently the case in former times (withlout linux-next)


In addition, there are some *very*interesting observations:

ALso I am pinging and everything works, iwconfig reports:
wlan0     IEEE 802.11abgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=15 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off


I also saw some WARNINGs in the dmesg output:
[17987.181066] Call Trace:
[17987.181072]  [<ffffffff8102b796>] warn_slowpath_common+0x83/0x9b
[17987.181075]  [<ffffffff8102b7c8>] warn_slowpath_null+0x1a/0x1c
[17987.181082]  [<ffffffffa0213fda>] iwl_send_lq_cmd+0x14a/0x246 [iwlwifi]
[17987.181090]  [<ffffffffa0214480>] iwl_restore_stations+0x206/0x279 [iwlwifi]
[17987.181097]  [<ffffffffa021c388>] iwlagn_commit_rxon+0x4b5/0x6a8 [iwlwifi]
[17987.181104]  [<ffffffffa021cc51>] iwlagn_bss_info_changed+0x307/0x504 [iwlwifi]
[17987.181115]  [<ffffffffa008c504>] ieee80211_bss_info_change_notify+0x179/0x1a3 [mac80211]
[17987.181127]  [<ffffffffa00b54aa>] ieee80211_destroy_auth_data+0x50/0x75 [mac80211]
[17987.181138]  [<ffffffffa00b84a6>] ieee80211_sta_work+0x9e/0x91d [mac80211]
...


----------------------------

But to repeat, the general feeling is much better, being able to have
a persistent ssh connection is a huge win!


Please let me know if you need any further testing, information, or
changes.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
DITHERINGTON (n)
Sudden access to panic experienced by one who realises that he is
being drawn inexorably into a clabby (q.v.) conversation, i.e. one he
has no hope of enjoying, benefiting from or understanding.
			--- Douglas Adams, The Meaning of Liff
