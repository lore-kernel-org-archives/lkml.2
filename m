Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969Ab2DLACL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:02:11 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:45746 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933835Ab2DLACG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:02:06 -0400
Date: Thu, 12 Apr 2012 09:02:02 +0900
From: Norbert Preining <preining@logic.at>
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: 3.4-rc2, ilwagn still most of the time completely unusable
Message-ID: <20120412000202.GA15286@gamma.logic.tuwien.ac.at>
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at> <20120411023747.GA10126@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Meenakshi,

thanks for your email

On Mi, 11 Apr 2012, Venkataraman, Meenakshi wrote:
> Sorry about the annoyance it is causing you...but let's see if we can solve the problems you're seeing.

Yes, let us make another trial ;-)

> >	delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
> >	Rx BA session stop requested for ...
> >*IF* it is connected.
> 
> [MV]  This is actually printed by mac80211 when it stops a block ack session; which can happen with bursty traffic. It's not an error per se. You'll see this message if you have debugging enabled for mac80211, specifically CONFIG_MAC80211_HT_DEBUG. Perhaps you could reduce the debugging information you print out for mac80211?

Probably I was asked to activate that at some point ;-) Will disactivate
it. Thanks.

> >On the contrary, it sometimes not even connects, after reloading the module,
> >retrying many times, today my log was smarmed with messages:
> >	[ 9457.156030] wlan0: authentication with 00:24:c4:ab:bd:e0 timed out
> >	[ 9457.176828] iwlwifi 0000:06:00.0: ACTIVATE a non DRIVER active
> >station id 0 addr 00:24:c4:ab:bd:e0
> 
> [MV]  this could potentially be a problem with our driver. I would like some logs to figure out what happened here. Can you send me a detailed dmesg log with debug=0xFFFFFFFF?  Thanks. :-)

I will do when I am back at university.

> >But I want to report *SOME* progress: Formerly I had *BIG* problems with
> >my home network (some strange Corega WL router AFAIR, Japanese only, but
> >it was working without a click before 2.6.38 or 39 or so).
> >Now, when I *DISABLE* 11n (11n_disable=1) then all the problems are gone
> >*AT*HOME*, no warnings anymore, no complains, no hickups.
> >On the university it is still a pain.
> 
> [MV] Any idea how 11n is performing with 3.4-rc2 on your home network? Are you seeing the same problems as before?

On the university often no connection at all.
At home: connection hangs for several seconds, when I look at the 
ping www.kernel.org I have more than 20% packet loss. And interestingly
quite often the ping looks like:
64 bytes from pub1.kernel.org (149.20.20.133): icmp_req=131 ttl=53 time=125 ms
64 bytes from pub1.kernel.org (149.20.20.133): icmp_req=133 ttl=53 time=124 ms
64 bytes from 149.20.20.133: icmp_req=134 ttl=53 time=135 ms
64 bytes from pub1.kernel.org (149.20.20.133): icmp_req=135 ttl=53 time=123 ms
64 bytes from pub1.kernel.org (149.20.20.133): icmp_req=136 ttl=53 time=121 ms
which does NOT relate in anyway to my feeling, because when I 
check the *real* time *before* the line
	64 bytes from 149.20.20.133: icmp_req=134 ttl=53 time=135 ms
there are *several* seconds, (3-4, sometimes more) of waiting time.

That of course destroys regularly every ssh and ftp connection.
http is of course not the problem (but who cares for the web?).

I have create a log with the above debug settings but 11n NOT disabled.
I also added some
	===== remarks =======
(variable number of =, tough, but at least always 4, so you can search
for ====) with logger "....". The log is *BIG*, compressed 3Mb, you
can find it here:
	http://www.logic.at/people/preining/syslog.bz2

Ok, when I have something from the university I will let you know.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
IPING (participial vb.)
The increasingly anxious shifting from leg to leg you go through when
you are desperate to go to the lavatory and the person you are talking
to keeps on remembering a few final things he want to mention.
			--- Douglas Adams, The Meaning of Liff
