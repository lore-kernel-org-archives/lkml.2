Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2CMGlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:41:12 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33548 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab2CMGlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:41:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUakjaxE3fTm1w3SuuE-cAXAg2fePmEdwmjomAgp88Psg@mail.gmail.com>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
 <1331617001-20906-5-git-send-email-apenwarr@gmail.com> <CAE9FiQUakjaxE3fTm1w3SuuE-cAXAg2fePmEdwmjomAgp88Psg@mail.gmail.com>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 13 Mar 2012 02:40:50 -0400
Message-ID: <CAHqTa-0b1DBDNYzDQ6UHHCivF9S-H3zvZWH0KZ21OQ8gQq6WYg@mail.gmail.com>
Subject: Re: [PATCH 4/5] printk: use alloc_bootmem() instead of memblock_alloc().
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Fabio M. Di Nitto" <fdinitto@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Olaf Hering <olaf@aepfle.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> that seems not right.
>
> for x86, setup_log_buf(1) is quite early called in setup_arch() before
> bootmem is there.
>
> bootmem should be killed after memblock is supported for arch that
> current support bootmem.

Hmm.  x86 uses nobootmem.c, which implements bootmem in terms of
memblock anyway.  It is definitely working at setup_log_buf() time (or
else it wouldn't be able to select a sensible buffer location).

I suppose you're saying that it wouldn't work for a hypothetical
architecture that *does* support bootmem and *also* supports
setup_log_buf(1).  Will there ever be such an architecture, or will
bootmem be retired first?

Thanks,

Avery
