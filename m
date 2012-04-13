Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab2DMBcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 21:32:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:63873 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab2DMBck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 21:32:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88529910"
From: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
To: Norbert Preining <preining@logic.at>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: RE: 3.4-rc2, ilwagn still most of the time completely unusable
Thread-Topic: 3.4-rc2, ilwagn still most of the time completely unusable
Thread-Index: AQHNF4xSbRLp8UBTpUGj9Ei8Jnp2cJaWQsUQgACCdACAASt1EA==
Date: Fri, 13 Apr 2012 01:32:38 +0000
Message-ID: <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com>
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at>
 <20120411023747.GA10126@gamma.logic.tuwien.ac.at>
 <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com>
 <20120412000202.GA15286@gamma.logic.tuwien.ac.at>
In-Reply-To: <20120412000202.GA15286@gamma.logic.tuwien.ac.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Norbert,

>> >	delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
>> >	Rx BA session stop requested for ...
>> >*IF* it is connected.
>>
>> [MV]  This is actually printed by mac80211 when it stops a block ack session;
>which can happen with bursty traffic. It's not an error per se. You'll see this
>message if you have debugging enabled for mac80211, specifically
>CONFIG_MAC80211_HT_DEBUG. Perhaps you could reduce the debugging
>information you print out for mac80211?
>
>Probably I was asked to activate that at some point ;-) Will disactivate it.
>Thanks.

[MV] Well...actually don't turn off this debugging yet. Johannes tells me that these messages could still be due to an issue with the driver. I was looking at the standards, and  Reason code 39 means that the peer (the AP) is requesting this due to a timeout. I  don't see that in the log you sent me, so not sure what timed out. However, I do see Rx BA session stop requests from the AP with reason code 32, which is based on the standard means "disassociated for unspecified QoS related reason".

In your logs I also see missed beacon notifications from the firmware ~every 500 milliseconds. My thought is that it is probably due to turning on power save. I'm not sure if it is affecting the performance of your system overall. Are you using the power save option? And if so, what is the behaviour when power save is turned off?

I don't see the invalid station activation error in the log you sent me, so I'm guessing it appears only on the other network. Do send us logs for that. 

If you're up for it, I'd ask you to do one thing  (or three) -- open 3 separate bugs for the issues you're seeing at: bugzilla.intellinuxwireless.org so we can keep track of them separately. The issue of trying to activate an invalid station ID is definitely a new one, and likely due to a different cause than that related to aggregation or the troubles you're having even with 11n disabled. I could do this too, and add you to the CC list. I might need logs for these bugs, but not yet.

Thanks,
Meenakshi
