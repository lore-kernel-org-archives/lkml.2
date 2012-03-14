Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030465Ab2CNCXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:23:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42460 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760347Ab2CNCXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:23:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVkn_jHhdFfDg_zvJJuZci+kvOd6NSfL4aSc_GP=hiOWw@mail.gmail.com>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
 <1331617001-20906-5-git-send-email-apenwarr@gmail.com> <CAE9FiQUakjaxE3fTm1w3SuuE-cAXAg2fePmEdwmjomAgp88Psg@mail.gmail.com>
 <CAHqTa-0b1DBDNYzDQ6UHHCivF9S-H3zvZWH0KZ21OQ8gQq6WYg@mail.gmail.com> <CAE9FiQVkn_jHhdFfDg_zvJJuZci+kvOd6NSfL4aSc_GP=hiOWw@mail.gmail.com>
From: Avery Pennarun <apenwarr@gmail.com>
Date: Tue, 13 Mar 2012 22:23:18 -0400
Message-ID: <CAHqTa-3p1sS1QvT3bg4UAo9G8Hq+-PJsSxBAz_P8pf+tdEOq4Q@mail.gmail.com>
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

On Tue, Mar 13, 2012 at 5:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Now you put back bootmem calling early, will cause confusion.
[...]
> we should use adding memblock_alloc calling instead... go backward...

Okay, I'm convinced.  I've updated my series so CONFIG_PRINTK_PERSIST
only works with HAVE_MEMBLOCK, and I've removed the patch to
unconditionally call bootmem in the existing non-PRINTK_PERSIST case.

(I'll upload the patches later once the other threads play out.)

Thanks for the quick feedback!

Avery
