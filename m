Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2FFHnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:43:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62370 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2FFHnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:43:31 -0400
MIME-Version: 1.0
In-Reply-To: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
Date: Wed, 6 Jun 2012 15:43:29 +0800
Message-ID: <CAGjg+kFhGwhjfxp3vmQbDVUyHiOfn1HMKBDgtjZKU_f+fw=JWw@mail.gmail.com>
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched domain support
From: Alex Shi <lkml.alex@gmail.com>
To: mingo@kernel.org, a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        cmetcalf@tilera.com, tony.luck@intel.com, sivanich@sgi.com,
        akpm@linux-foundation.org, ralf@linux-mips.org, greg.pearson@hp.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net,
        kamezawa.hiroyu@jp.fujitsu.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, anton@samba.org,
        lethal@linux-sh.org, davem@davemloft.net, benh@kernel.crashing.org,
        dhowells@redhat.com, mattst88@gmail.com, fenghua.yu@intel.com,
        Alex Shi <alex.shi@intel.com>
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +       /*
> +        * O(nr_nodes^2) deduplicating selection sort -- in order to find the
> +        * unique distances in the node_distance() table.
> +        *
> +        * Assumes node_distance(0,j) includes all distances in
> +        * node_distance(i,j) in order to avoid cubic time.

Curious for other platforms node_distance number, actually, this
assumption is right for what I saw Intel platforms. but it is not
match acpispec50.pdf:

Table 6-152 Example Relative Distances Between Proximity Domains
Proximity Domain 0 1 2 3
0 10 15 20 18
1 15 10 16 24
2 20 16 10 12
3 18 24 12 10


Alex
