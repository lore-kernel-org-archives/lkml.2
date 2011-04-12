Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab1DLBB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 21:01:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42950 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab1DLBB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 21:01:27 -0400
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
In-Reply-To: <1302557371.7286.16607.camel@nimitz>
References: <20110411172004.0361.A69D9226@jp.fujitsu.com> <1302557371.7286.16607.camel@nimitz>
Message-Id: <20110412100129.43F1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 12 Apr 2011 10:01:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2011-04-11 at 17:19 +0900, KOSAKI Motohiro wrote:
> > This patch raise zone_reclaim_mode threshold to 30. 30 don't have
> > specific meaning. but 20 mean one-hop QPI/Hypertransport and such
> > relatively cheap 2-4 socket machine are often used for tradiotional
> > server as above. The intention is, their machine don't use
> > zone_reclaim_mode.
> 
> I know specifically of pieces of x86 hardware that set the information
> in the BIOS to '21' *specifically* so they'll get the zone_reclaim_mode
> behavior which that implies.

Which hardware?
The reason why now we decided to change default is the original bug reporter was using
mere commodity whitebox hardware and very common workload. 
If it is enough commotidy, we have to concern it. but if it is special, we don't care it.
Hardware vendor should fix a firmware.


> They've done performance testing and run very large and scary benchmarks
> to make sure that they _want_ this turned on.  What this means for them
> is that they'll probably be de-optimized, at least on newer versions of
> the kernel.
> 
> If you want to do this for particular systems, maybe _that_'s what we
> should do.  Have a list of specific configurations that need the
> defaults overridden either because they're buggy, or they have an
> unusual hardware configuration not really reflected in the distance
> table.

No. It's no my demand. It's demand from commodity hardware. you can fix
your company firmware, but we can't change commodity ones.



