Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab0IHNxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:53:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48177 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab0IHNxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:53:07 -0400
Subject: Re: [RFC PATCH 1/2] perf_events: add support for per-cpu
 per-cgroup monitoring (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com
In-Reply-To: <4c8793a9.cde7d80a.3bb6.0290@mx.google.com>
References: <4c8793a9.cde7d80a.3bb6.0290@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Sep 2010 15:52:47 +0200
Message-ID: <1283953967.23762.22.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-08 at 15:30 +0200, Stephane Eranian wrote:
> +       } times[NR_CPUS] ____cacheline_aligned_in_smp;

That's fail! NR_CPUS can be like 4k for distro configs.

Use proper per-cpu allocations.
