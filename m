Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab2GGTnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 15:43:41 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42718 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2GGTnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 15:43:39 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <pool@lists.ntp.org>, <linux-kernel@vger.kernel.org>
References: <015e01cd5c52$eb27a510$c176ef30$@lucidpixels.com>
In-Reply-To: <015e01cd5c52$eb27a510$c176ef30$@lucidpixels.com>
Subject: RE: X9SCM-F-O clock drift +1 second into the future when ntp running?
Date: Sat, 7 Jul 2012 15:43:37 -0400
Message-ID: <01ed01cd5c78$cdc25b70$69471250$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJQVqFgYmNwtcgEmqsB/un6pmpdWJYYPRCw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com] 
Sent: Saturday, July 07, 2012 11:12 AM
To: pool@lists.ntp.org; linux-kernel@vger.kernel.org
Subject: X9SCM-F-O clock drift +1 second into the future when ntp running?

Hello,

I migrated from an X7SPA to an X9SCM-F-O and now gpsd/ntp no longer sync
with my GPS unit:
http://www.amazon.com/GlobalSat-BU-353-USB-GPS-Receiver/dp/B000PKX2KA

I did some digging and it looks like the system clock on this motherboard
with the latest BIOS (2.00a) runs 1 second too fast when comparing to other
NTP-synchronized machines.

--

I've done some more reading and what I've found is anything over 500ppm ntp
cannot correct for; so is this would be a bad crystal/chip or is there
something else wrong here?

Supermicro X9SCM: (see the error_ppm) is all over the map:

# adjtimex -a
                                      --- current ---   -- suggested --
cmos time     system-cmos  error_ppm   tick      freq    tick      freq
1341688282      -0.731743
1341688292      -0.731619       12.4   9993   3497075
1341688302      -0.747186    -1556.7   9993   3497075   10009    659788
1341688312      -0.747117        6.9   9993   3497075    9993   3045513
1341688322      -0.747099        1.8   9993   3497075    9993   3378325
1341688332      -0.762636    -1553.7   9993   3378325   10009    344163
1341688342      -0.762650       -1.4   9993   3378325    9993   3470512
1341688352      -0.778221    -1557.1   9993   3378325   10009    566038

# adjtimex -a
                                      --- current ---   -- suggested --
cmos time     system-cmos  error_ppm   tick      freq    tick      freq
1341688564      -0.591964
1341688574      -0.575373     1659.1  10009    566038
1341688584      -0.574515       85.8  10009    566038   10008   1497763
1341688594      -0.558007     1650.8  10009    566038    9992   3789738
1341688604      -0.537084     2092.3  10009    566038    9988   1071325
1341688614      -0.568492    -3140.8   9988   1071325   10019   3744100
1341688624      -0.568774      -28.2   9988   1071325    9988   2919762
1341688634      -0.584618    -1584.4   9988   1071325   10004     49663

Old MSI motherboard (Pentium 4-- see how the PPM is roughly in the same
range)

#  adjtimex -a
WARNING: CMOS time is 30.02 min ahead of system clock
                                      --- current ---   -- suggested --
cmos time     system-cmos  error_ppm   tick      freq    tick      freq
1341690163   -1800.416735
1341690173   -1800.417111      -37.6   9996   2365500
1341690183   -1800.417499      -38.7   9996   2365500    9996   4904456
1341690193   -1800.417894      -39.5   9996   2365500    9996   4956019
1341690203   -1800.418297      -40.3   9996   2365500    9996   5007582
1341690213   -1800.418308       -1.0   9996   5007582    9996   5074664
1341690223   -1800.418327       -1.9   9996   5007582    9996   5134039
1341690233   -1800.418353       -2.6   9996   5007582    9996   5179351

Found this:
http://compgroups.net/comp.protocols.time.ntp/hopelessly-broken-clock/490495

set clocksource=hpet for boot options instead of TSC

Did not make any difference, still all over the map:

# adjtimex -a
                                      --- current ---   -- suggested --
cmos time     system-cmos  error_ppm   tick      freq    tick      freq
1341690087       0.238485
1341690097       0.240449      196.4  10015   1475154
1341690107       0.257408     1695.9  10015   1475154    9998   1744166
1341690117       0.274176     1676.8  10015   1475154    9998   2995729
1341690127       0.290927     1675.1  10015   1475154    9998   3106666
1341690137       0.291142       21.5   9998   3106666    9998   1697291
1341690147       0.275783    -1535.9   9998   3106666   10013   5458916
1341690157       0.276029       24.6   9998   3106666    9998   1494166

Has anyone seen anything like this before?
I checked all of the BIOS options, did not see anything out of the ordinary
here..

Justin.

