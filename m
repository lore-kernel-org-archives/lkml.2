Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab2DYBGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 21:06:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:6075 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654Ab2DYBGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 21:06:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="145539058"
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
Thread-Index: AQHNF4xSbRLp8UBTpUGj9Ei8Jnp2cJaWQsUQgACCdACAASt1EIAAxQMAgBIX3IA=
Date: Wed, 25 Apr 2012 01:06:17 +0000
Message-ID: <4595B4D22AB93C4FABBA84AAD5AA37FD136757@ORSMSX103.amr.corp.intel.com>
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at>
 <20120411023747.GA10126@gamma.logic.tuwien.ac.at>
 <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com>
 <20120412000202.GA15286@gamma.logic.tuwien.ac.at>
 <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com>
 <20120413053858.GA4057@gamma.logic.tuwien.ac.at>
In-Reply-To: <20120413053858.GA4057@gamma.logic.tuwien.ac.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Norbert,

>WIth that turned off I *believe* I have better results, but I will tet
>it a bi tmore.

[MV] How is this looking now?

>> I don't see the invalid station activation error in the log you sent me, so I'm
>guessing it appears only on the other network. Do send us logs for that.
>
>Now I got one ....
>	http://www.logic.at/people/preining/syslog-debug.bz2
>take care, unpacked it is big!

[MV]  I'm going through this log -- don't have a root cause for this yet, but getting closer to it. I see in this log that authentication is timing out. It appears that the driver sent out the authentication frame, and received some frame OTA, but I can't tell what it received from just the dmesg log. I'd like some trace-cmd logs from you. Is it possible for you to collect a trace-cmd log and send over the binary to me?

>One more thing, I believe that this happens most of the times
>(but not necessarily exclusively, but I don't have statistics)
>after resume (from suspend to ram).

[MV]  This is good to know. I wonder if this is related to the PCIe l used on your platform. Can you try to use PCIe link state management to L0s in your BIOS and see if the stability of your system improves?

>>So saying, it seems that with power_save=0 even if I get several of
>these:
>[ 1601.552069] tx session timer expired on tid 0
>[ 1601.552116] Tx BA session stop requested for 00:24:c4:ab:bd:e0 tid 0
>[ 1601.576292] Stopping Tx BA session for 00:24:c4:ab:bd:e0 tid 0
>[ 1603.470312] Open BA session requested for 00:24:c4:ab:bd:e0 tid 0
>[ 1603.480274] activated addBA response timer on tid 0
>[ 1603.483479] switched off addBA timer for tid 0
>[ 1603.483485] Aggregation is on for tid 0
>the connection does not break down, as before. Well, I am not sure whether
>it is a consequence or coincidence.

[MV] the tx session timer expiry ... hmm... I haven't looked at it. Otherwise, it seems to be Tx Aggregation sessions being turned on and turned off, so perhaps we will reduce the debug level at which it is printed. One of us is looking at the frequency with which these messages are being reported.

Thanks,
Meenakshi
