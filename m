Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090Ab2GLQQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:16:53 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:47541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933647Ab2GLQQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:16:51 -0400
Message-ID: <1342109807.4531.38.camel@jlt3.sipsolutions.net>
Subject: Re: [Ilw]  Re: 3.4-rc2, ilwagn still most of the time completely
 unusable
From: Johannes Berg <johannes@sipsolutions.net>
To: Norbert Preining <preining@logic.at>
Cc: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
        "Lin, Hsien KuoX" <hsien.kuox.lin@intel.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emmanuel Grumbach <egrumbach@gmail.com>
Date: Thu, 12 Jul 2012 18:16:47 +0200
In-Reply-To: <20120712081457.GA32465@gamma.logic.tuwien.ac.at>
References: <20120412000202.GA15286@gamma.logic.tuwien.ac.at>
	 <4595B4D22AB93C4FABBA84AAD5AA37FD120BF8@ORSMSX103.amr.corp.intel.com>
	 <20120413014047.GB25681@gamma.logic.tuwien.ac.at>
	 <20120330011734.GH6277@gamma.logic.tuwien.ac.at>
	 <20120411023747.GA10126@gamma.logic.tuwien.ac.at>
	 <4595B4D22AB93C4FABBA84AAD5AA37FD11DE3C@ORSMSX103.amr.corp.intel.com>
	 <20120412000202.GA15286@gamma.logic.tuwien.ac.at>
	 <20120628072512.GF31944@gamma.logic.tuwien.ac.at>
	 <1340869868.4491.4.camel@jlt3.sipsolutions.net>
	 <20120628081607.GG31944@gamma.logic.tuwien.ac.at>
	 <20120712081457.GA32465@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 17:14 +0900, Norbert Preining wrote:

> > I can actually work now wirelessly, and in case of hangs an rfkill block
> > rfkill unblock practically always, and mostly is not needed.
> 
> Ok, that was said *UNTIL* I reenabled 11n. Up to now I was loading the
> iwlwifi module with
> 	11n_disable=1
> 
> Now, latest git from today, I though, let us try to enable 11n again,
> and there we go, boot from cold machine and after short time everything
> is dead without reaction. Dmesg gives many many funny messages:
> 
> [   30.047943] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
> [   30.051933] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
> [   30.164836] iwlwifi 0000:06:00.0: L1 Enabled; Disabling L0S
> [   30.167876] iwlwifi 0000:06:00.0: Radio type=0x1-0x2-0x0
> [   37.533619] wlan0: authenticate with 00:0a:79:eb:56:10
> [   37.536433] wlan0: send auth to 00:0a:79:eb:56:10 (try 1/3)
> [   37.538241] wlan0: authenticated
> [   37.538391] wlan0: associating with AP with corrupt beacon

That might be an indication of things already going wrong with your
AP ... :-(

[snip log]

Mostly from the log it seems that there's a lot of spurious aggregation
setup/teardown, some of it seems to originate from the AP.

> At that point I removed the iwlwifi module, and reloaded it with 
> 11n_disable=1 again, otherwise nothing would work at all...

With the latest, I've extended 11n_disable to have more bits.

11n_disable=1 will disable HT completely
11n_disable=2 will disable TX aggregation
11n_disable=4 will disable RX aggregation

It'd be interesting to see what happens for you with 11n_disable=2/4/6.

johannes

