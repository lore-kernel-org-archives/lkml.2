Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1DLH0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:26:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59461 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab1DLH0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:26:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH resend^2] mm: increase RECLAIM_DISTANCE to 30
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Chris McDermott <lcm@linux.vnet.ibm.com>
In-Reply-To: <1302575241.7286.17853.camel@nimitz>
References: <20110412100129.43F1.A69D9226@jp.fujitsu.com> <1302575241.7286.17853.camel@nimitz>
Message-Id: <20110412162631.B51C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 12 Apr 2011 16:25:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2011-04-12 at 10:01 +0900, KOSAKI Motohiro wrote:
> > > On Mon, 2011-04-11 at 17:19 +0900, KOSAKI Motohiro wrote:
> > > > This patch raise zone_reclaim_mode threshold to 30. 30 don't have
> > > > specific meaning. but 20 mean one-hop QPI/Hypertransport and such
> > > > relatively cheap 2-4 socket machine are often used for tradiotional
> > > > server as above. The intention is, their machine don't use
> > > > zone_reclaim_mode.
> > > 
> > > I know specifically of pieces of x86 hardware that set the information
> > > in the BIOS to '21' *specifically* so they'll get the zone_reclaim_mode
> > > behavior which that implies.
> > 
> > Which hardware?
> 
> I'd have to go digging for the model numbers.  I just remember having
> discussions with folks about it a couple of years ago.  My memory isn't
> what it used to be. :)

O.K.

> 
> > The reason why now we decided to change default is the original bug reporter was using
> > mere commodity whitebox hardware and very common workload. 
> > If it is enough commotidy, we have to concern it. but if it is special, we don't care it.
> > Hardware vendor should fix a firmware.
> 
> Yeah, it's certainly a "simple" fix.  The distance tables can certainly
> be adjusted easily, and worked around pretty trivially with boot
> options.  If we decide to change the generic case, let's also make sure
> that we put something else in place simultaneously that is nice for the
> folks that don't want it changed.  Maybe something DMI-based that digs
> for model numbers?

That pretty makes sense. If you can find exacl model number, I'm fully
assist this portion.


> I'll go try and dig for some more specifics on the hardware so we at
> least have something to test on.

Thank you!



