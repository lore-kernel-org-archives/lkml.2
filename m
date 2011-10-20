Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1JTHk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 03:40:28 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:43597 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab1JTHk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 03:40:27 -0400
Subject: Re: iwlagn is getting very shaky
From: Johannes Berg <johannes@sipsolutions.net>
To: Norbert Preining <preining@logic.at>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20111020045927.GB23044@gamma.logic.tuwien.ac.at> (sfid-20111020_065949_480246_E6D70D7B)
References: <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
	 <1319004836.31823.57.camel@wwguy-huron>
	 <20111019124931.GC3963@gamma.logic.tuwien.ac.at>
	 <1319038282.25023.21.camel@wwguy-ubuntu>
	 <20111019060108.GA11588@gamma.logic.tuwien.ac.at>
	 <alpine.DEB.2.00.1110182305110.7719@chino.kir.corp.google.com>
	 <20111019062517.GC11588@gamma.logic.tuwien.ac.at>
	 <1319003304.31823.46.camel@wwguy-huron>
	 <20111019064628.GA14817@gamma.logic.tuwien.ac.at>
	 <1319004836.31823.57.camel@wwguy-huron>
	 <20111020045927.GB23044@gamma.logic.tuwien.ac.at>
	 (sfid-20111020_065949_480246_E6D70D7B)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 09:40:18 +0200
Message-ID: <1319096418.3959.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 13:59 +0900, Norbert Preining wrote:

> so I am now at the university, and it seems your last patch
> did wonder. Here a log after waking up from suspend at university...

For some value of wonder ...

> [17394.896199] wlan0: associated
> [17394.974620] iwlagn 0000:06:00.0: Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (2)
> [17394.976930] iwlagn 0000:06:00.0: Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (2)
> [17409.608674] iwlagn 0000:06:00.0: Tx aggregation enabled on ra = 00:24:c4:ab:bd:ef tid = 0
> [17409.616748] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
> [17409.816093] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
> [17410.016083] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
> [17410.216086] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
> [17419.285141] iwlagn 0000:06:00.0: Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (0)
> [17419.285315] iwlagn 0000:06:00.0: Encounter TX_STATUS_FAIL_PASSIVE_NO_RX, am I on 5.2G band? (0)
> [17419.286583] wlan0: deauthenticating from 00:24:c4:ab:bd:ef by local choice (reason=2)
> [17419.300296] cfg80211: Calling CRDA for country: JP
> [17419.309278] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
> [17419.310105] wlan0: authenticated
> [17419.317900] wlan0: associate with 00:24:c4:ab:bd:ef (try 1)

It seems a bit like the 5 GHz AP (:e0) just fails, and wpa_supplicant
selects a 2.4 GHz AP (:ef) now? Pure conjecture, I guess the AP could
also be on the same channel -- did you have scan information for these
APs?

johannes

