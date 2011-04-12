Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab1DLC1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 22:27:30 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46210 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab1DLC13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 22:27:29 -0400
Subject: Re: [PATCH resend^2] mm: increase RECLAIM_DISTANCE to 30
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Chris McDermott <lcm@linux.vnet.ibm.com>
In-Reply-To: <20110412100129.43F1.A69D9226@jp.fujitsu.com>
References: <20110411172004.0361.A69D9226@jp.fujitsu.com>
	 <1302557371.7286.16607.camel@nimitz>
	 <20110412100129.43F1.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 11 Apr 2011 19:27:21 -0700
Message-ID: <1302575241.7286.17853.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 10:01 +0900, KOSAKI Motohiro wrote:
> > On Mon, 2011-04-11 at 17:19 +0900, KOSAKI Motohiro wrote:
> > > This patch raise zone_reclaim_mode threshold to 30. 30 don't have
> > > specific meaning. but 20 mean one-hop QPI/Hypertransport and such
> > > relatively cheap 2-4 socket machine are often used for tradiotional
> > > server as above. The intention is, their machine don't use
> > > zone_reclaim_mode.
> > 
> > I know specifically of pieces of x86 hardware that set the information
> > in the BIOS to '21' *specifically* so they'll get the zone_reclaim_mode
> > behavior which that implies.
> 
> Which hardware?

I'd have to go digging for the model numbers.  I just remember having
discussions with folks about it a couple of years ago.  My memory isn't
what it used to be. :)

> The reason why now we decided to change default is the original bug reporter was using
> mere commodity whitebox hardware and very common workload. 
> If it is enough commotidy, we have to concern it. but if it is special, we don't care it.
> Hardware vendor should fix a firmware.

Yeah, it's certainly a "simple" fix.  The distance tables can certainly
be adjusted easily, and worked around pretty trivially with boot
options.  If we decide to change the generic case, let's also make sure
that we put something else in place simultaneously that is nice for the
folks that don't want it changed.  Maybe something DMI-based that digs
for model numbers?

I'll go try and dig for some more specifics on the hardware so we at
least have something to test on.

-- Dave

