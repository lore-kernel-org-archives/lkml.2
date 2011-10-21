Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab1JUBYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 21:24:15 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:44251 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab1JUBYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 21:24:13 -0400
Date: Fri, 21 Oct 2011 10:23:54 +0900
From: Norbert Preining <preining@logic.at>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: iwlagn is getting very shaky
Message-ID: <20111021012354.GA26758@gamma.logic.tuwien.ac.at>
References: <20111019124931.GC3963@gamma.logic.tuwien.ac.at> <1319038282.25023.21.camel@wwguy-ubuntu> <20111019060108.GA11588@gamma.logic.tuwien.ac.at> <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com> <20111019062517.GC11588@gamma.logic.tuwien.ac.at> <1319003304.31823.46.camel@wwguy-huron> <20111019064628.GA14817@gamma.logic.tuwien.ac.at> <1319004836.31823.57.camel@wwguy-huron> <20111020045927.GB23044@gamma.logic.tuwien.ac.at> <1319096418.3959.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319096418.3959.1.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Do, 20 Okt 2011, Johannes Berg wrote:
> > [17409.616748] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
..
> > [17419.285141] iwlagn 0000:06:00.0: Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (0)
> > [17419.286583] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
> > [17419.300296] cfg80211: Calling CRDA for country: JP
> > [17419.309278] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
> > [17419.310105] wlan0: authenticated
> > [17419.317900] wlan0: associate with 00:24:c4:ab:bd:ef (try 1)
> 
> It seems a bit like the 5 GHz AP (:e0) just fails, and wpa_supplicant
> selects a 2.4 GHz AP (:ef) now? Pure conjecture, I guess the AP could
> also be on the same channel -- did you have scan information for these
> APs?

BSS 00:24:c4:ab:bd:e0 (on wlan0)
        TSF: 8728607601135 usec (101d, 00:36:47)
        freq: 2412
        beacon interval: 102
        capability: ESS ShortPreamble ShortSlotTime (0x0421)
        signal: -62.00 dBm
        last seen: 6012 ms ago
        SSID: XXXXXX
        Supported rates: 1.0* 2.0* 5.5* 6.0 9.0 11.0* 12.0 18.0 
        DS Parameter set: channel 1
        TIM: DTIM Count 0 DTIM Period 1 Bitmap Control 0x0 Bitmap[0] 0x0
        Country: JP     Environment: Indoor/Outdoor
                Channels [1 - 13] @ 20 dBm
        ERP: Use_Protection
        HT capabilities:
                Capabilities: 0x182c
                        HT20
                        SM Power Save disabled
                        RX HT20 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        Extended supported rates: 24.0 36.0 48.0 54.0 
        HT operation:
                 * primary channel: 1
                 * secondary channel offset: no secondary
                 * STA channel width: 20 MHz
                 * RIFS: 0
                 * HT protection: non-HT mixed
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec


And the one I am on:
BSS 00:24:c4:ab:bd:ef (on wlan0) -- associated
        TSF: 8728558719143 usec (101d, 00:35:58)
        freq: 5200
        beacon interval: 102
        capability: ESS (0x0001)
        signal: -69.00 dBm
        last seen: 96 ms ago
        Information elements from Probe Response frame:
        SSID: XXXXXX
        Supported rates: 6.0* 9.0 12.0* 18.0 24.0* 36.0 48.0 54.0 
        Country: JP     Environment: Indoor/Outdoor
                Channels [36 - 64] @ 22 dBm
        HT capabilities:
                Capabilities: 0x186e
                        HT20/HT40
                        SM Power Save disabled
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 8 usec (0x06)
                HT RX MCS rate indexes supported: 0-15
                HT TX MCS rate indexes are undefined
        HT operation:
                 * primary channel: 40
                 * secondary channel offset: below
                 * STA channel width: any
                 * RIFS: 1
                 * HT protection: no
                 * non-GF present: 1
                 * OBSS non-GF present: 0
                 * dual beacon: 0
                 * dual CTS protection: 0
                 * STBC beacon: 0
                 * L-SIG TXOP Prot: 0
                 * PCO active: 0
                 * PCO phase: 0
        WMM:     * Parameter version 1
                 * u-APSD
                 * BE: CW 15-1023, AIFSN 3
                 * BK: CW 15-1023, AIFSN 7
                 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
                 * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec


No idea if that helps you.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SCREGGAN (n. banking)
The crossed-out bit caused by people putting the wrong year on their
cheques all through January.
			--- Douglas Adams, The Meaning of Liff
