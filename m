Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1DVAe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:34:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60929 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab1DVAe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:34:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
Cc: kosaki.motohiro@jp.fujitsu.com,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
In-Reply-To: <alpine.DEB.2.00.1104211230030.5829@chino.kir.corp.google.com>
References: <20110421221712.9184.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211230030.5829@chino.kir.corp.google.com>
Message-Id: <20110422093406.FA56.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 22 Apr 2011 09:34:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 21 Apr 2011, KOSAKI Motohiro wrote:
> 
> > ia64 and mips have CONFIG_ARCH_POPULATES_NODE_MAP and it initialize
> > N_NORMAL_MEMORY automatically if my understand is correct.
> > (plz see free_area_init_nodes)
> > 
> 
> ia64 doesn't enable CONFIG_HIGHMEM, so it never gets set via this generic 
> code; mips also doesn't enable it for all configs even for 32-bit.
> 
> So we'll either want to take check_for_regular_memory() out from under 
> CONFIG_HIGHMEM and do it for all configs or teach slub to use 
> N_HIGH_MEMORY rather than N_NORMAL_MEMORY.

Hey, I already told this thing.

If CONFIG_HIGHMEM=n, N_HIGH_MEMORY and N_NORMAL_MEMORY are share the
same value. then, 
	node_set_state(nid, N_HIGH_MEMORY) in free_area_init_nodes()

mean set both N_HIGH_MEMORY and N_NORMAL_MEMORY.


