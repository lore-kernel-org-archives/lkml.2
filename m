Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2CMXjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:39:19 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:52351 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2CMXjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:39:17 -0400
Date: Wed, 14 Mar 2012 08:39:00 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
Message-ID: <20120313233900.GE13820@gamma.logic.tuwien.ac.at>
References: <CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com> <CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com> <20120126232555.GB16330@gamma.logic.tuwien.ac.at> <20120127015015.GA23291@gamma.logic.tuwien.ac.at> <CANUX_P3F58upbrw48AiMTV4DDZWsfveYp=mANAD9CQ2bPps0cA@mail.gmail.com> <20120222003747.GA9808@gamma.logic.tuwien.ac.at> <CAOJsxLHoX2WU7xJ8etXsz32B=QhOADvMzBYzsuBR2YXvv44PyA@mail.gmail.com> <CANUX_P1CN0Ud5ZO4AMcvMSUsrsEABRHkgy42Di45n96mB64Ynw@mail.gmail.com> <20120227083612.GA5648@gamma.logic.tuwien.ac.at> <CANUX_P2jtrByqAJTAZDu-+5Nx-cYFKiO8Hkhepg7rDbEmNwfJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUX_P2jtrByqAJTAZDu-+5Nx-cYFKiO8Hkhepg7rDbEmNwfJQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel,

(now at -rc6)

On Mo, 27 Feb 2012, Emmanuel Grumbach wrote:
> > Now I did:
> > kernel 3.3-rc5
> >
> > On Mi, 22 Feb 2012, Emmanuel Grumbach wrote:
> >> From the log, I can see that we have a lot of "passive channel
> >> failures". Can you try to disable 11n (module_parameter) ?
> >> Please also try with debug=0xc0000000
> 
> So this doesn't seem to be related to my rework of the AMPDU logic....
> Will keep you updated if I think about something.

Another thing ... I don't know what the hack is going on here, since
-rc6 I think I get *loads* of messages:
	delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
After last reboot in about 10min (920.95) I got 414 of these lines.
Always in a triple:
[  914.882870] delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
[  914.882881] Rx BA session stop requested for 00:0a:79:eb:56:10 tid 0 inititator reason: 0
[  915.012136] Rx A-MPDU request on tid 0 result 0
[  916.157983] delba from 00:0a:79:eb:56:10 (initiator) tid 0 reason code 39
...

No idea if that helps in any way, but it is new.

Interestingly, after doing rfkill block wifi; sleep 10; rfkill unblock wifi,
and that sometimes 2 or three times, at some point these messages disappear
and I have only:
[18876.624068] tx session timer expired on tid 0
[18876.624117] Tx BA session stop requested for 00:0a:79:eb:56:10 tid 0
[18876.644224] Stopping Tx BA session for 00:0a:79:eb:56:10 tid 0
[18877.609764] Open BA session requested for 00:0a:79:eb:56:10 tid 0
[18877.640279] activated addBA response timer on tid 0
[18877.642218] switched off addBA timer for tid 0
[18877.642224] Aggregation is on for tid 0
(again many of them)

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
MELCOMBE REGIS (n.)
The name of the style of decoration used in cocktail lounges in mock
Tudor hotels in Surrey.
			--- Douglas Adams, The Meaning of Liff
