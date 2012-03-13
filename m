Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab2CMVug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:50:36 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43187 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab2CMVue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:50:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAHqTa-0b1DBDNYzDQ6UHHCivF9S-H3zvZWH0KZ21OQ8gQq6WYg@mail.gmail.com>
References: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
	<1331617001-20906-5-git-send-email-apenwarr@gmail.com>
	<CAE9FiQUakjaxE3fTm1w3SuuE-cAXAg2fePmEdwmjomAgp88Psg@mail.gmail.com>
	<CAHqTa-0b1DBDNYzDQ6UHHCivF9S-H3zvZWH0KZ21OQ8gQq6WYg@mail.gmail.com>
Date: Tue, 13 Mar 2012 14:50:34 -0700
X-Google-Sender-Auth: m64GE8LbC9d0s1CpE-fXxdkL0Js
Message-ID: <CAE9FiQVkn_jHhdFfDg_zvJJuZci+kvOd6NSfL4aSc_GP=hiOWw@mail.gmail.com>
Subject: Re: [PATCH 4/5] printk: use alloc_bootmem() instead of memblock_alloc().
From: Yinghai Lu <yinghai@kernel.org>
To: Avery Pennarun <apenwarr@gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 11:40 PM, Avery Pennarun <apenwarr@gmail.com> wrote:
>> that seems not right.
>>
>> for x86, setup_log_buf(1) is quite early called in setup_arch() before
>> bootmem is there.
>>
>> bootmem should be killed after memblock is supported for arch that
>> current support bootmem.
>
> Hmm.  x86 uses nobootmem.c, which implements bootmem in terms of
> memblock anyway.  It is definitely working at setup_log_buf() time (or
> else it wouldn't be able to select a sensible buffer location).


ok, you may could do that now.
only after recent changes from Tejun, that kill early_node_map().

before that, we only can use nobootmem after
arch/x86/kernel/setup.c::setup_arch/initmem_init()
but memblock alloc could be used just after
arch/x86/kernel/setup.c::setup_arch/memblock_x86_fill()

Now you put back bootmem calling early, will cause confusion.

>
> I suppose you're saying that it wouldn't work for a hypothetical
> architecture that *does* support bootmem and *also* supports
> setup_log_buf(1).  Will there ever be such an architecture, or will
> bootmem be retired first?

we should use adding memblock_alloc calling instead... go backward...

Thanks

Yinghai
