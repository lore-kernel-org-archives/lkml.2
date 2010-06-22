Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab0FVIGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:06:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:37100 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab0FVIGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,459,1272870000"; 
   d="scan'208";a="810228966"
Subject: Re: [rfc] Describe events in a structured way via sysfs
From: Lin Ming <ming.m.lin@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Greg KH <greg@kroah.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1277192364.3637.10.camel@jlt3.sipsolutions.net>
References: <1274233602.3036.84.camel@localhost>
	 <20100518200524.GA20223@kroah.com>
	 <1274236496.3603.22.camel@minggr.sh.intel.com>
	 <20100519024823.GA25229@kroah.com>	<1274253276.5605.10124.camel@twins>
	 <20100520184213.GB21030@kroah.com>	<20100520201418.GB11470@elte.hu>
	 <20100520231229.GB8335@kroah.com>	<1274429038.1674.1684.camel@laptop>
	 <20100521094053.GA4658@elte.hu>
	 <AANLkTimf1Z0N9cv2Pu2qTTUscn4utC37zOPelCbqQoPv@mail.gmail.com>
	 <1277110509.18390.28.camel@minggr.sh.intel.com>
	 <1277112858.3618.16.camel@jlt3.sipsolutions.net>
	 <1277187920.4467.3.camel@minggr.sh.intel.com>
	 <1277189971.3637.5.camel@jlt3.sipsolutions.net>
	 <1277191359.5025.4.camel@minggr.sh.intel.com>
	 <1277192007.3637.8.camel@jlt3.sipsolutions.net>
	 <1277192364.3637.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Tue, 22 Jun 2010 16:04:07 +0800
Message-Id: <1277193847.5025.19.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 15:39 +0800, Johannes Berg wrote:
> On Tue, 2010-06-22 at 09:33 +0200, Johannes Berg wrote:
> 
> > > > > net/wlan0/events/
> > > > > net/waln1/events/
> > > > > ....
> > > > > net/walnN/events/
> > > > 
> > > > That's not appropriate either though since you may have multiple network
> > > > interfaces on the same hardware :)
> > > 
> > > Doesn't net/wlan0...wlanN mean multiple network interfaces on the same
> > > hardware?
> > 
> > Yes, but the trace points aren't per network interface but rather per
> > hardware piece.
> 
> Which really just means that whoever writes the tracepoint needs to
> provide a struct device for where to put it (at least in the case of
> driver tracepoints), and then ideally some description of the device
> also gets put into the ringbuffer.

I'm not familiar with tracepoint code. Correct me if I'm wrong.
Do you mean that, for example, if iwlwifi_dev_ioread32 event is traced,
then the "device" info will get put into the ftrace ringbuffer?

> 
> Assuming you actually want to have the event show up in sysfs twice if
> it has multiple producers? I'd like that, it would make sense for a lot
> of cases since you might only care about one of the producers.

Yes, each producers has a "events" sysfs dir.

> 
> johannes
> 

