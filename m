Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2DMFjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 01:39:09 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:36435 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab2DMFjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 01:39:06 -0400
Date: Fri, 13 Apr 2012 14:38:58 +0900
From: Norbert Preining <preining@logic.at>
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: 3.4-rc2, ilwagn still most of the time completely unusable
Message-ID: <20120413053858.GA4057@gamma.logic.tuwien.ac.at>
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at> <20120411023747.GA10126@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com> <20120412000202.GA15286@gamma.logic.tuwien.ac.at> <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Meenakshi,

On Fr, 13 Apr 2012, Venkataraman, Meenakshi wrote:
> In your logs I also see missed beacon notifications from the firmware ~every 500 milliseconds. My thought is that it is probably due to turning on power save. I'm not sure if it is affecting the performance of your system overall. Are you using the power save option? And if so, what is the behaviour when power save is turned off?

Good point. I have now changed iwlwifi to load with power_save=0
because as I found someone (don't ask me who!, nm? gnome? acpi?)
turns on power saving.

WIth that turned off I *believe* I have better results, but I will tet
it a bi tmore.

> I don't see the invalid station activation error in the log you sent me, so I'm guessing it appears only on the other network. Do send us logs for that. 

Now I got one ....
	http://www.logic.at/people/preining/syslog-debug.bz2
take care, unpacked it is big!

One more thing, I believe that this happens most of the times
(but not necessarily exclusively, but I don't have statistics)
after resume (from suspend to ram).

So saying, it seems that with power_save=0 even if I get several of
these:
[ 1601.552069] tx session timer expired on tid 0
[ 1601.552116] Tx BA session stop requested for 00:24:c4:ab:bd:e0 tid 0
[ 1601.576292] Stopping Tx BA session for 00:24:c4:ab:bd:e0 tid 0
[ 1603.470312] Open BA session requested for 00:24:c4:ab:bd:e0 tid 0
[ 1603.480274] activated addBA response timer on tid 0
[ 1603.483479] switched off addBA timer for tid 0
[ 1603.483485] Aggregation is on for tid 0
the connection does not break down, as before. Well, I am not sure whether
it is a consequence or coincidence.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
GWEEK (n.)
A coat hanger recycled as a car aerial.
			--- Douglas Adams, The Meaning of Liff
