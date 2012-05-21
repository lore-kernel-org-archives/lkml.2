Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab2EUSS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:18:27 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60428 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab2EUSSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:18:25 -0400
MIME-Version: 1.0
In-Reply-To: <1337623623.1997.115.camel@sbsiddha-desk.sc.intel.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120521082240.GA31407@gmail.com> <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
 <20120521124025.GC17065@gmail.com> <20120521144812.GD28930@dhcp-26-207.brq.redhat.com>
 <20120521145904.GA7068@gmail.com> <CA+55aFxJxfx+OfDiATCCPojVAPew_Hy+2=jx9g4=2_WRvixBFw@mail.gmail.com>
 <1337623623.1997.115.camel@sbsiddha-desk.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 May 2012 11:18:04 -0700
X-Google-Sender-Auth: Gbohhl2SsaDI3DrLyyeSHAeKV6M
Message-ID: <CA+55aFx3ogOzGWZvfETgoKqoLzTc7qw6QjmouSLG4JF9aRdjig@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Alexander Gordeev <agordeev@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:07 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
>
> All the cluster members of a given x2apic cluster belong to the same
> package. These x2apic cluster id's are setup by the HW and not by the
> SW. And only one cluster (with one or multiple members of that cluster
> set) can be specified in the interrupt destination field of the routing
> table entry.

Ok, then the main question ends up being if there are enough cache or
power domains within a cluster to still worry about it.

For example, you say "package", but that can sometimes mean multiple
dies, or even just split caches that are big enough to matter
(although I can't think of any such right now on the x86 side - Core2
Duo had huge L2's, but they were shared, not split).

> Power aware interrupt routing in IVB does this. And the policy of
> whether you want the interrupt to be routed to the busy core (to save
> power) or an idle core (for minimizing the interruptions on the busy
> core) can be selected by the SW (using IA32_ENERGY_PERF_BIAS MSR).

Sounds like we definitely would want to support this at least in the
IVB timeframe then.

But I do agree with Ingo that it would be really good to actually see
numbers (and no, I don't mean "look here, now the irq's are nicely
spread out", but power and/or performance numbers showing that it
actually helps something).

                   Linus
