Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1DTHP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 03:15:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57461 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab1DTHP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 03:15:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
Cc: kosaki.motohiro@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        David Rientjes <rientjes@google.com>
In-Reply-To: <BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com> <BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com>
Message-Id: <20110420161615.462D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 20 Apr 2011 16:15:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Apr 20, 2011 at 4:23 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > I'm worry about this patch. A lot of mm code assume !NUMA systems
> > only have node 0. Not only SLUB.
> 
> So is that a valid assumption or not? Christoph seems to think it is
> and James seems to think it's not. Which way should we aim to fix it?
> Would be nice if other people chimed in as we already know what James
> and Christoph think.

I'm sorry. I don't know it really. The fact was gone into historical myst. ;-)

Now, CONFIG_NUMA has mainly five meanings.

1) system may has !0 node id.
2) compile mm/mempolicy.c (ie enable mempolicy APIs)
3) Allocator (kmalloc, vmalloc, alloc_page, et al) awake NUMA topology.
4) enable zone-reclaim feature
5) scheduler makes per-node load balancing scheduler domain

Anyway, we have to fix this issue.  I'm digging which fixing way has least risk.


btw, x86 don't have an issue. Probably it's a reason why this issue was neglected
long time.

arch/x86/Kconfig
-------------------------------------
config ARCH_DISCONTIGMEM_ENABLE
        def_bool y
        depends on NUMA && X86_32



