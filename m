Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1DOI3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 04:29:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51218 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab1DOI3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 04:29:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v2] cpusets: randomize node rotor used in cpuset_mem_spread_node()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <20110415082051.GB8828@tiehlicka.suse.cz>
References: <20110415161831.12F8.A69D9226@jp.fujitsu.com> <20110415082051.GB8828@tiehlicka.suse.cz>
Message-Id: <20110415172855.12FF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 15 Apr 2011 17:29:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [I just realized that I forgot to CC mm mailing list]
> 
> On Fri 15-04-11 16:18:45, KOSAKI Motohiro wrote:
> > Oops.
> > I should have look into !mempolicy part too.
> > I'm sorry.
> > 
> [...]
> > Michal, I think this should be
> > 
> > #ifdef CONFIG_CPUSETS
> > 	if (cpuset_do_page_mem_spread())
> > 		p->cpuset_mem_spread_rotor = node_random(&p->mems_allowed);
> > 	if (cpuset_do_slab_mem_spread())
> > 		p->cpuset_slab_spread_rotor = node_random(&p->mems_allowed);
> > #endif
> > 
> > because 99.999% people don't use cpuset's spread mem/slab feature and
> > get_random_int() isn't zero cost.
> > 
> > What do you think?
> 
> You are right. I was thinking about lazy approach and initialize those
> values when they are used for the first time. What about the patch
> below?
> 
> Change from v1:
> - initialize cpuset_{mem,slab}_spread_rotor lazily

Yeah! This is much much better than mine. Thank you!
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



