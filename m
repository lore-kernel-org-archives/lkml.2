Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1JSGZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 02:25:30 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:54108 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1JSGZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 02:25:29 -0400
Date: Wed, 19 Oct 2011 15:25:17 +0900
From: Norbert Preining <preining@logic.at>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>, ilw@linux.intel.com,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111019062517.GC11588@gamma.logic.tuwien.ac.at>
References: <20111019060108.GA11588@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, hi all

On Di, 18 Okt 2011, David Rientjes wrote:
> There have been recent issues in 3.1-rc9 reported with iwlagn, see the 
> thread at https://lkml.org/lkml/2011/10/15/107 even though you have 

Interesting. I read through the thread and activated the debugfs 
option.

I could get my hardware back by
	echo 1 > /sys/kernel/debug/ieee80211/phy0/iwlagn/debug/force_reset

[ 2761.352629] ieee80211 phy0: Hardware restart was requested
[ 2761.352714] iwlagn 0000:06:00.0: L1 Enabled; Disabling L0S
[ 2761.355763] iwlagn 0000:06:00.0: Radio type=0x1-0x2-0x0
[ 2779.484308] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[ 2779.684128] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[ 2779.884087] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[ 2780.084079] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
[ 2788.051381] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[ 2788.248079] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[ 2788.448083] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[ 2788.648140] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
[ 2796.614710] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
[ 2796.615623] wlan0: authenticated
[ 2796.618046] wlan0: associate with 00:24:c4:ab:bd:ef (try 1)
[ 2796.622748] wlan0: RX AssocResp from 00:24:c4:ab:bd:ef (capab=0x1 status=0 aid=1)
[ 2796.622751] wlan0: associated
[ 2871.224192] e1000e: eth0 NIC Link is Down

I unplugged the cable and could ping the world still, nice....

After a short time I got:
[ 2895.575964] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[ 2895.772067] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[ 2895.972101] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[ 2896.172054] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
[ 2905.316968] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
[ 2905.356316] cfg80211: Calling CRDA to update world regulatory domain
[ 2905.361965] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 1)
[ 2905.560063] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 2)
[ 2905.760091] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 3)
[ 2905.960077] wlan0: authentication with 00:24:c4:ab:bd:e0 timed out
[ 2913.908984] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[ 2914.108116] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[ 2914.308116] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[ 2914.508103] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
[ 2922.473062] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
[ 2922.672109] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
[ 2922.872106] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
[ 2923.072103] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out

And at this time the tx_queue showed me:
------------------------------------------------------------
hwq 00: read=91 write=91 stop=1 swq_id=0x00 (ac 0/hwq 0)
        stop-count: 1
hwq 01: read=0 write=0 stop=0 swq_id=0x05 (ac 1/hwq 1)
        stop-count: 0
hwq 02: read=127 write=127 stop=0 swq_id=0x0a (ac 2/hwq 2)
        stop-count: 0
hwq 03: read=0 write=0 stop=0 swq_id=0x0f (ac 3/hwq 3)
        stop-count: 0
hwq 04: read=13 write=13 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 05: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 06: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 07: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 08: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 09: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 10: read=0 write=0 stop=0 swq_id=0x2a (ac 2/hwq 10)
hwq 11: read=0 write=0 stop=0 swq_id=0x2c (ac 0/hwq 11)
hwq 12: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 13: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 14: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 15: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 16: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 17: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 18: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
hwq 19: read=0 write=0 stop=0 swq_id=0x00 (ac 0/hwq 0)
-------------------------------------------------

Hope that helps. Anyone let me know if you need more testing.

Once more, be reminded the the firmware of the iwlagn is from
an experimental build that should solve the AGN stopped working
problem.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SCRAMOGE (vb.)
To cut oneself whilst licking envelopes.
			--- Douglas Adams, The Meaning of Liff
