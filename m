Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab1KSUCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 15:02:09 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:56347 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab1KSUCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 15:02:06 -0500
Date: Sat, 19 Nov 2011 21:02:34 +0100
From: Nico Schottelius <nico-linux-20111118@schottelius.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        Nico -telmich- Schottelius 
	<nico-linux-20111118@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: b43: BCM 4331: MacBook 8,1: No connection after suspend
Message-ID: <20111119200234.GA2140@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20111118@schottelius.org>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
References: <20111118173242.GA2101@schottelius.org>
 <20111118173921.GB2101@schottelius.org>
 <4EC6B9E9.50204@broadcom.com>
 <4EC6BB5E.4010101@broadcom.com>
 <CACna6ryw9gC5CnY-ex45JFmQtXRxs8NX9ADkqVZrOj5CCtjiVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACna6ryw9gC5CnY-ex45JFmQtXRxs8NX9ADkqVZrOj5CCtjiVw@mail.gmail.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.2.0-rc1 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafał Miłecki [Sat, Nov 19, 2011 at 12:08:51AM +0100]:
> > In brcmsmac we reprogram the PCI BAR windows upon resume. Not sure if
> > that is done or needed in bcma, but may be worth checking.
> 
> Good point.
> 
> Please reload b43 *and bcma*. Both drivers. Share your results.

Well, 100 points for you!

rmmod of b43 and bcma and modprobe of b43 afterwards restores
the ability to connect!

Btw, I've found another issue: The signal level seems to be set
to 0 for all networks, thus wpa_supplicant does not select the
best network (Follow the white rabbit! in my case). Thus
I've used "select_network 9" to force connection to the right
networt.

Log attached below.

So, what are the next steps to debug/fix this issue to make me
(and probably everybody else with a macbook pro 8,1) happy after
suspend?

Cheers,

Nico

> scan_results 
bssid / frequency / signal level / flags / ssid
02:0c:42:14:17:01 2412  0 [WPA-EAP-TKIP+CCMP][WPA2-EAP-TKIP+CCMP][ESS]  MONZOON-EAP
00:24:c9:85:e1:60 2412  0 [WPA-PSK-TKIP+CCMP][WPA2-PSK-TKIP+CCMP][WPS][ESS] mtp-35864
60:33:4b:e4:a5:c1 2417  0 [WPA2-PSK-CCMP][ESS]  airport
94:44:52:76:7b:76 2412  0 [WPA-PSK-CCMP][WPA2-PSK-CCMP][WPS][ESS] Belkin.3B76
00:24:93:27:1f:b0 2422  0 [WPA-PSK-TKIP][WPA2-PSK-CCMP][ESS]  vwp-20691
80:c6:ab:2a:05:19 2437  0 [WPA-PSK-TKIP+CCMP][WPA2-PSK-TKIP+CCMP][ESS]  UPC0045190
00:21:1e:65:b0:d0 2447  0 [WPA-PSK-TKIP][WPA2-PSK-CCMP][ESS]  CDQ-69729
00:18:e7:e8:7b:49 2472  0 [WPA-PSK-TKIP+CCMP][WPA2-PSK-TKIP+CCMP][WPS][ESS] MHLAN
00:0c:42:14:17:01 2412  0 [ESS] MONZOON
00:18:39:50:07:f3 2462  0 [ESS] Follow the white rabbit!
00:22:3f:2e:53:94 2462  0 [WPA-PSK-TKIP+CCMP][WPA2-PSK-TKIP+CCMP-preauth][ESS]  strudele
> 
Linux brief 3.2.0-rc1 #83 SMP PREEMPT Tue Nov 8 15:54:52 CET 2011 x86_64 Intel(R) Core(TM) i5-2415M CPU @ 2.30GHz GenuineIntel GNU/Linux

connected, now suspending:

<2>CTRL-EVENT-DISCONNECTED bssid=00:00:00:00:00:00 reason=0
> <2>CTRL-EVENT-SCAN-RESULTS 
> <2>WPS-AP-AVAILABLE 
> <2>Trying to associate with 00:18:39:50:07:f3 (SSID='Follow the white rabbit!' freq=2462 MHz)
> <2>Associated with 00:18:39:50:07:f3
> <2>CTRL-EVENT-CONNECTED - Connection to 00:18:39:50:07:f3 completed (reauth) [id=9 id_str=yvonne]
<2>CTRL-EVENT-DISCONNECTED bssid=00:18:39:50:07:f3 reason=0
> <2>CTRL-EVENT-SCAN-RESULTS 
> <2>WPS-AP-AVAILABLE 
> <2>Trying to associate with 00:18:39:50:07:f3 (SSID='Follow the white rabbit!' freq=2462 MHz)
<2>Authentication with 00:18:39:50:07:f3 timed out.
> 
> terminate 
OK
[20:18] brief:~# rmmod b43
[20:19] brief:~# rmmod bcma
[20:19] brief:~# modprobe b43
WARNING: All config files need .conf: /etc/modprobe.d/modprobe.conf.pacnew, it will be ignored in a future release.
[20:19] brief:~# lsmod| head -3 
Module                  Size  Used by
b43                   355422  0 
bcma                   22546  1 b43
[20:19] brief:~# 
> status 
wpa_state=ASSOCIATING
<2>Authentication with 00:0c:42:14:17:01 timed out.
> <2>CTRL-EVENT-BSS-ADDED 11 94:44:52:51:2e:8a
> <2>CTRL-EVENT-SCAN-RESULTS 
> <2>WPS-AP-AVAILABLE 
> <2>Trying to associate with 00:18:39:50:07:f3 (SSID='Follow the white rabbit!' freq=2462 MHz)
> <2>Associated with 00:18:39:50:07:f3
> <2>CTRL-EVENT-CONNECTED - Connection to 00:18:39:50:07:f3 completed (auth) [id=9 id_str=yvonne]

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
