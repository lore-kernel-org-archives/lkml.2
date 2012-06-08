Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556Ab2FHWhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:37:05 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55422 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761131Ab2FHWhB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:37:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120608165330.GE4777@dhcp-26-207.brq.redhat.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
	<20120606082231.GD5991@gmail.com>
	<20120607131559.GF4759@dhcp-26-207.brq.redhat.com>
	<1339107848.28766.104.camel@sbsiddha-desk.sc.intel.com>
	<20120608165330.GE4777@dhcp-26-207.brq.redhat.com>
Date: Fri, 8 Jun 2012 15:36:57 -0700
X-Google-Sender-Auth: 8dL7eunmRbIgH4blF6F0RSdKnGM
Message-ID: <CAE9FiQU7h4oXmJOPHVTvat7epujeAWodZWMZU5MAJs0TNkLeLg@mail.gmail.com>
Subject: Re: [PATCH] x86/apic: Eliminate cpu_mask_to_apicid() operation
From: Yinghai Lu <yinghai@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 9:53 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> Since there are only two locations where cpu_mask_to_apicid() is called
> from, remove the operation and use only cpu_mask_to_apicid_and() instead.
>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/x86/include/asm/apic.h           |   33 ++++++++-------------------------
>  arch/x86/kernel/apic/apic.c           |   24 ++++++------------------
>  arch/x86/kernel/apic/apic_flat_64.c   |    2 --
>  arch/x86/kernel/apic/apic_noop.c      |    1 -
>  arch/x86/kernel/apic/apic_numachip.c  |    1 -
>  arch/x86/kernel/apic/bigsmp_32.c      |    1 -
>  arch/x86/kernel/apic/es7000_32.c      |    4 +---
>  arch/x86/kernel/apic/io_apic.c        |    3 ++-
>  arch/x86/kernel/apic/numaq_32.c       |    8 --------
>  arch/x86/kernel/apic/probe_32.c       |    1 -
>  arch/x86/kernel/apic/summit_32.c      |    3 +--
>  arch/x86/kernel/apic/x2apic_cluster.c |   17 -----------------
>  arch/x86/kernel/apic/x2apic_phys.c    |    1 -
>  arch/x86/kernel/apic/x2apic_uv_x.c    |   29 ++++++-----------------------
>  arch/x86/platform/uv/uv_irq.c         |    2 +-
>  15 files changed, 25 insertions(+), 105 deletions(-)

good, kill 80 lines.

Acked-by: Yinghai Lu <yinghai@kernel.org>
