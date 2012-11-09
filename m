Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2KIUGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:06:20 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:41997 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753193Ab2KIUGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:06:17 -0500
Date: Fri, 9 Nov 2012 20:06:16 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>,
        Robert Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
        "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH v6 25/29] memcg/sl[au]b: shrink dead caches
In-Reply-To: <20121108144043.baf9f2e5.akpm@linux-foundation.org>
Message-ID: <0000013ae6c7ac4a-138f8469-5fa2-4a2e-b569-0717659f0c9e-000000@email.amazonses.com>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com> <1351771665-11076-26-git-send-email-glommer@parallels.com> <20121105164813.2eba5ecb.akpm@linux-foundation.org> <509A0A04.2030503@parallels.com> <20121106231627.3610c908.akpm@linux-foundation.org>
 <509A2849.9090509@parallels.com> <20121107144612.e822986f.akpm@linux-foundation.org> <0000013ae1050e6f-7f908e0b-720a-4e68-a275-e5086a4f5c74-000000@email.amazonses.com> <20121108112120.fc964c29.akpm@linux-foundation.org> <509C32B4.7050105@parallels.com>
 <20121108144043.baf9f2e5.akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2012, Andrew Morton wrote:

> I'd still like to give ACPI a thwap.  That kmem_cache_shrink() in
> drivers/acpi/osl.c was added unchangelogged in a megapatch
> (73459f73e5d1602c59) so it's a mystery.  Cc's optimistically added.

It does not hurt though and releasing cache objects when there will be no
objects added and removed from a slab cache is a good thing to do.
