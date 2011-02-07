Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1BGEAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 23:00:47 -0500
Received: from smtp106.rog.mail.re2.yahoo.com ([68.142.225.204]:41666 "HELO
	smtp106.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754237Ab1BGEAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 23:00:46 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Feb 2011 23:00:45 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Message-ID:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:Organization:User-Agent:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=RemUCiE/tBE2Df8BWZNlhye4Z3kn6KP/H3jrzCppE9RXRyTrk4zELvUexNJtve2V09l+0K8h/0M0gQPKMwVpRLenU374PORSTRYdtz4wAoG5rG6PIxepftoqmAKIMr9ggqoR6D/tJAbSv6QSVuzBTiUuBjX5er7aJNllnnfyghQ=  ;
Message-ID: <613373.34172.qm@smtp106.rog.mail.re2.yahoo.com>
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: 5RRlcucVM1k2xHJuIYVsMDV1Lrk6mJHqKZEzvLwypF84rJZ
 zd8Ep0fHNd4OwtHgu2AZiQURrbEgygkaZ6DTvTfrKUqy9HJYZB.Cdo8dpUN3
 gJB4k5wWOlxiiv3.ranCQNB1tfg5yL0vXaPEM.BPuY0gi.EBk5wuSYfqWSA7
 AM2_ccNhiQyGkGk1IivoVx2O7GQywF_uDldFQX6Pflr8J63q6KcOvyRdpjFx
 H26q.WJwQ0hUQUPRC3O53gtm4R686
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: [regression][2.6.38-rcX][net][iwlagn] WiFi signal after period of time tanks causing contant drops
Date: Sun, 06 Feb 2011 22:54 -0500
Organization: sh0n.net
User-Agent: KMail/4.6 beta4 (Linux/2.6.38-0.rc3.git4.1.fc15.x86_64; KDE/4.6.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using a Intel Corporation PRO/Wireless 5100 AGN [Shiloh] card after rebooting 
and a period of of seveal hours signal begins to drop to low levels:


wlan0     IEEE 802.11abgn  ESSID:"XXXXXXXX"  
          Mode:Managed  Frequency:2.462 GHz  Access Point: AA:BB:CC:DD:EE:FF   
          Bit Rate=11 Mb/s   Tx-Power=15 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=12/70  Signal level=-98 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:35   Missed beacon:0

...

          Link Quality=12/70  Signal level=-98 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:40   Missed beacon:0

I start seeing lots of Invalid misc errors and connection drops. If I reboot, 
then signal will be back to normal for a period of time again.

My official kernel is from Fedora rawhide (2.6.38-0.rc3.git4.1.fc15.x86_64)

Anyone else notice poor link/signal levels?

.37 showed no such issues.


-- snip -- 

kernel messages when this occurred:


[15110.285207] CE: hpet increased min_delta_ns to 20113 nsec
[33809.732205] cfg80211: Calling CRDA to update world regulatory domain
[33809.831816] cfg80211: World regulatory domain updated:
[33809.831819] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[33809.831822] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[33809.831825] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[33809.831827] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[33809.831830] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[33809.831832] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[33809.831841] cfg80211: Calling CRDA for country: US
[33809.835215] cfg80211: Regulatory domain changed to country: US
[33809.835217] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[33809.835220] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2700 mBm)
[33809.835223] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 1700 mBm)
[33809.835225] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[33809.835228] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[33809.835230] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[33809.835233] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 3000 mBm)
[33812.364119] wlan0: authenticate with aa:bb:cc:dd:ee:ff (try 1)
[33812.366620] wlan0: authenticated
[33812.366643] wlan0: waiting for beacon from aa:bb:cc:dd:ee:ff
[33828.410709] wlan0: authenticate with aa:bb:cc:dd:ee:ff (try 1)
[33828.413725] wlan0: authenticated
[33828.413748] wlan0: waiting for beacon from aa:bb:cc:dd:ee:ff
[33828.418428] wlan0: beacon received
[33828.421042] wlan0: associate with aa:bb:cc:dd:ee:ff (try 1)
[33828.446039] wlan0: RX AssocResp from aa:bb:cc:dd:ee:ff (capab=0x411 
status=0 aid=1)
[33828.446042] wlan0: associated
[34100.737227] cfg80211: Calling CRDA to update world regulatory domain
[34100.740353] cfg80211: World regulatory domain updated:
[34100.740355] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[34100.740358] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34100.740361] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[34100.740363] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[34100.740366] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34100.740368] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34100.740378] cfg80211: Calling CRDA for country: US
[34100.742781] cfg80211: Regulatory domain changed to country: US
[34100.742784] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[34100.742787] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2700 mBm)
[34100.742789] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 1700 mBm)
[34100.742792] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34100.742794] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34100.742797] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34100.742799] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 3000 mBm)
[34103.381063] wlan0: authenticate with aa:bb:cc:dd:ee:ff (try 1)
[34103.385675] wlan0: authenticated
[34103.385707] wlan0: waiting for beacon from aa:bb:cc:dd:ee:ff
[34103.465542] wlan0: beacon received
[34103.468042] wlan0: associate with aa:bb:cc:dd:ee:ff (try 1)
[34103.470316] wlan0: RX AssocResp from aa:bb:cc:dd:ee:ff (capab=0x411 
status=0 aid=1)
[34103.470319] wlan0: associated
[34114.737244] cfg80211: Calling CRDA to update world regulatory domain
[34114.739837] cfg80211: World regulatory domain updated:
[34114.739840] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[34114.739843] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34114.739846] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[34114.739848] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[34114.739851] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34114.739853] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34114.739863] cfg80211: Calling CRDA for country: US
[34114.742475] cfg80211: Regulatory domain changed to country: US
[34114.742477] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[34114.742480] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2700 mBm)
[34114.742483] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 1700 mBm)
[34114.742485] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34114.742488] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34114.742490] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34114.742493] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 3000 mBm)
[34124.964949] wlan0: authenticate with aa:bb:cc:dd:ee:ff (try 1)
[34124.967818] wlan0: authenticated
[34124.967842] wlan0: waiting for beacon from aa:bb:cc:dd:ee:ff
[34124.969754] wlan0: beacon received
[34124.972015] wlan0: associate with aa:bb:cc:dd:ee:ff (try 1)
[34124.974327] wlan0: RX AssocResp from aa:bb:cc:dd:ee:ff (capab=0x411 
status=0 aid=1)
[34124.974329] wlan0: associated
[34249.738240] cfg80211: Calling CRDA to update world regulatory domain
[34249.740811] cfg80211: World regulatory domain updated:
[34249.740814] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[34249.740817] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34249.740819] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[34249.740822] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 
mBi, 2000 mBm)
[34249.740824] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34249.740827] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34249.740835] cfg80211: Calling CRDA for country: US
[34249.743295] cfg80211: Regulatory domain changed to country: US
[34249.743298] cfg80211:     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[34249.743300] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 
mBi, 2700 mBm)
[34249.743303] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 
mBi, 1700 mBm)
[34249.743305] cfg80211:     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34249.743308] cfg80211:     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34249.743310] cfg80211:     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 
mBi, 2000 mBm)
[34249.743313] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 
mBi, 3000 mBm)
[34252.430829] wlan0: authenticate with aa:bb:cc:dd:ee:ff (try 1)
[34252.433740] wlan0: authenticated
[34252.433765] wlan0: waiting for beacon from aa:bb:cc:dd:ee:ff
[34275.365426] wlan0: authenticate with aa:bb:cc:dd:ee:ff (try 1)
[34275.367527] wlan0: authenticated
[34275.367552] wlan0: waiting for beacon from aa:bb:cc:dd:ee:ff
[35121.713088] wlan0: authenticate with aa:bb:cc:dd:ee:ff (try 1)
[35121.716042] wlan0: authenticated
[35121.716079] wlan0: waiting for beacon from aa:bb:cc:dd:ee:ff
[35121.743282] wlan0: beacon received
[35121.746047] wlan0: associate with aa:bb:cc:dd:ee:ff (try 1)
[35121.750694] wlan0: RX AssocResp from aa:bb:cc:dd:ee:ff (capab=0x411 
status=0 aid=2)
[35121.750697] wlan0: associated

Thanks, 
Shawn.



