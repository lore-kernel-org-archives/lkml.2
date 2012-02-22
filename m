Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2BVAiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 19:38:06 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41379 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab2BVAiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 19:38:04 -0500
Date: Wed, 22 Feb 2012 09:37:48 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
Message-ID: <20120222003747.GA9808@gamma.logic.tuwien.ac.at>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at> <CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com> <20120125002250.GA20431@gamma.logic.tuwien.ac.at> <CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com> <20120126003735.GA2346@gamma.logic.tuwien.ac.at> <CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com> <CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com> <20120126232555.GB16330@gamma.logic.tuwien.ac.at> <20120127015015.GA23291@gamma.logic.tuwien.ac.at> <CANUX_P3F58upbrw48AiMTV4DDZWsfveYp=mANAD9CQ2bPps0cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANUX_P3F58upbrw48AiMTV4DDZWsfveYp=mANAD9CQ2bPps0cA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emmanuel,

sorry to come back soo late to that matter ... I was *really* busy
with real work.

On Do, 26 Jan 2012, Emmanuel Grumbach wrote:
> >
> > On Fr, 27 Jan 2012, Norbert Preining wrote:
> >> First tests are promising, after reboot it was working immediately
> >> without need to rfkill block/unblock. lso after suspend and resume.
> >>
> >> Will test more the next days and report back.
> >
> > Unfortunately, at the university it is still a complete no-go.
> > Usually the connection works for a short time, then breaks down.
> > After that even unloading and loading the module did not reactivate
> > it, I cannot get a connection at all. But other units, or with
> > older kernel (it was 2.6.3X AFAIR) it was working without a glitch.
> >
> > I uploaded a syslog output including kernel and network manager logs
> > to
> >        http://www.logic.at/people/preining/syslog.log
> > (new one). This shows a session from loading the module up to giving up.
> >
> 
> I glanced at the logs, and they look healthy from the wifi driver
> side. You just don't get any reply to DHCP_DISCOVER apparently... can
> you get a sniffer ?
> I am pretty sure that the packet in sent in the air, but if you can
> get a capture of that we could check that out.

I still see that, on 3.3-rc4, and it is the same as usual. The interface
believes it is up and connected, but nothing works.

I am *100%* sure that this is related to the driver, because in old
revisions (somewhen around 2.6.27 or so) it was working without
any problem, and when it started I reported it long time ago.

Anyway, today it was really hopeless again, and the exact time it always
hangs is when the kernel driver spits out:
	Rx A-MPDU request on tid 0 result 0
and with debugging on I get in addition:
	ieee80211 phy3: release an RX reorder frame due to timeout on earlier frames
that is where it all goes down the gully, without any reaction from the
outside world suddenly. Before ping was running, then off.

I uploaded a new syslog.log in the above location that shows 5 min
or so of trial and error.

I don't know what else to provide then that, but it is definitely 
a real problem, I cannot work without cable anymore at the university,
which is a serious rpbolem.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
HAUGHAM (n.)
One who loudly informs other diners in a restaurant what kind of man
he is by calling for the chef by his christian name from the lobby.
			--- Douglas Adams, The Meaning of Liff
