Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965489Ab2DKXYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:24:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:57703 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965223Ab2DKXYn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:24:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140653248"
From: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
To: Norbert Preining <preining@logic.at>,
        Emmanuel Grumbach <egrumbach@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: RE: 3.4-rc2, ilwagn still most of the time completely unusable
Thread-Topic: 3.4-rc2, ilwagn still most of the time completely unusable
Thread-Index: AQHNF4xSbRLp8UBTpUGj9Ei8Jnp2cJaWQsUQ
Date: Wed, 11 Apr 2012 23:24:31 +0000
Message-ID: <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com>
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at>
 <20120411023747.GA10126@gamma.logic.tuwien.ac.at>
In-Reply-To: <20120411023747.GA10126@gamma.logic.tuwien.ac.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Norbert,

Sorry about the annoyance it is causing you...but let's see if we can solve the problems you're seeing.

>I already have reported that with 3.3-wl there are hundreds and thousands of
>lines
>	delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
>	Rx BA session stop requested for ...
>*IF* it is connected.

[MV]  This is actually printed by mac80211 when it stops a block ack session; which can happen with bursty traffic. It's not an error per se. You'll see this message if you have debugging enabled for mac80211, specifically CONFIG_MAC80211_HT_DEBUG. Perhaps you could reduce the debugging information you print out for mac80211?

>On the contrary, it sometimes not even connects, after reloading the module,
>retrying many times, today my log was smarmed with messages:
>	[ 9457.156030] wlan0: authentication with 00:24:c4:ab:bd:e0 timed out
>	[ 9457.176828] iwlwifi 0000:06:00.0: ACTIVATE a non DRIVER active
>station id 0 addr 00:24:c4:ab:bd:e0

[MV]  this could potentially be a problem with our driver. I would like some logs to figure out what happened here. Can you send me a detailed dmesg log with debug=0xFFFFFFFF?  Thanks. :-)

>But I want to report *SOME* progress: Formerly I had *BIG* problems with
>my home network (some strange Corega WL router AFAIR, Japanese only, but
>it was working without a click before 2.6.38 or 39 or so).
>Now, when I *DISABLE* 11n (11n_disable=1) then all the problems are gone
>*AT*HOME*, no warnings anymore, no complains, no hickups.
>On the university it is still a pain.

[MV] Any idea how 11n is performing with 3.4-rc2 on your home network? Are you seeing the same problems as before?

Thanks,
Meenakshi

