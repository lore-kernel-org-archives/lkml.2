Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1DTC54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 22:57:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59595 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1DTC5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 22:57:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
Cc: kosaki.motohiro@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>
In-Reply-To: <1303267733.11237.42.camel@mulgrave.site>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com> <1303267733.11237.42.camel@mulgrave.site>
Message-Id: <20110420115804.461E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 20 Apr 2011 11:57:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2011-04-20 at 10:23 +0900, KOSAKI Motohiro wrote:
> > > On Tue, 19 Apr 2011, James Bottomley wrote:
> > > 
> > > > > Which part of me telling you that you will break lots of other things in
> > > > > the core kernel dont you get?
> > > >
> > > > I get that you tell me this ... however, the systems that, according to
> > > > you, should be failing to get to boot prompt do, in fact, manage it.
> > > 
> > > If you dont use certain subsystems then it may work. Also do you run with
> > > debuggin on.
> > > 
> > > The following patch is I think what would be needed to fix it.
> > 
> > I'm worry about this patch. A lot of mm code assume !NUMA systems 
> > only have node 0. Not only SLUB.
> > 
> > I'm not sure why this unfortunate mismatch occur. but I think DISCONTIG
> > hacks makes less sense. Can we consider parisc turn NUMA on instead?
> 
> Well, you mean a patch like this?  It won't build ... obviously we need
> some more machinery
> 
>   CC      arch/parisc/kernel/asm-offsets.s
> In file included from include/linux/sched.h:78,
>                  from arch/parisc/kernel/asm-offsets.c:31:
> include/linux/topology.h:212:2: error: #error Please define an appropriate SD_NODE_INIT in include/asm/topology.h!!!
> In file included from include/linux/sched.h:78,
>                  from arch/parisc/kernel/asm-offsets.c:31:
> include/linux/topology.h: In function 'numa_node_id':
> include/linux/topology.h:255: error: implicit declaration of function 'cpu_to_node'

Sorry about that. I'll see more carefully the code later. Probably long
time discontig-mem uninterest made multiple level breakage. Grr. ;-)



