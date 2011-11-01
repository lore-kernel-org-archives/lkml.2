Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1KASrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:47:49 -0400
Received: from smtp.multi.fi ([85.134.37.151]:51044 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1KASrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:47:48 -0400
Message-ID: <4EB03E22.2090304@mageia.org>
Date: Tue, 01 Nov 2011 20:44:50 +0200
From: Thomas Backlund <tmb@mageia.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: spamm of cfg80211: Calling CRDA to update world regulatory domain
References: <4EB00DD3.7090701@gmail.com>
In-Reply-To: <4EB00DD3.7090701@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock skrev 1.11.2011 17:18:
> is there a way to get rid of this annoying spamming of the regulatory?
>
>
> [ 338.519037] cfg80211: Calling CRDA to update world regulatory domain
> [ 338.523266] cfg80211: World regulatory domain updated:
> [ 338.523269] cfg80211: (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [ 338.523272] cfg80211: (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
> mBi, 2000 mBm)
> [ 338.523276] cfg80211: (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
> mBi, 2000 mBm)
> [ 338.523279] cfg80211: (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
> mBi, 2000 mBm)
> [ 338.523281] cfg80211: (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
> mBi, 2000 mBm)
> [ 338.523284] cfg80211: (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
> mBi, 2000 mBm)
> [ 340.948738] wlan1: authenticate with 00:1d:a2:d8:7e:70 (try 1)
> [ 340.950479] wlan1: authenticated
> [ 340.950707] wlan1: associate with 00:1d:a2:d8:7e:70 (try 1)
> [ 340.953611] wlan1: RX ReassocResp from 00:1d:a2:d8:7e:70 (capab=0x401
> status=0 aid=79)
> [ 340.953614] wlan1: associated
> [ 458.646604] wlan1: deauthenticated from 00:1d:a2:d8:7e:70 (Reason: 2)
>
>
> my entire syslog is filled with the above.
>


Are you using networkmanager or systemd or even both ?
Atleast at some point networkmanager have had problems when trying to
activate wireless faster than the hw like, so you get into
auth/deauth loop, and for every time interface restart gets detected,
setting crda gets triggered.

For me systemd also has had the same problems for me from time to time,
and the only way to get wireless up then is to disable it for a
~5+ seconds with the hw killswitch, and when I re-enable it, network 
comes up as intended.

This happends for me with atleast 3.0 and 3.1 kernels and Intel 4965AGN 
wireless connecting to a 11N 5GHz AP.

--
Thomas
