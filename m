Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab2CSVqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:46:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39560 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab2CSVqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:46:46 -0400
Date: Mon, 19 Mar 2012 17:42:41 -0400 (EDT)
Message-Id: <20120319.174241.1785009482969692029.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: indan@nul.nu, wad@chromium.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, hpa@zytor.com, mingo@redhat.com,
        oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org, matt@ozlabs.org
Subject: Re: [PATCH] net: bpf_jit: fix BPF_S_LDX_B_MSH compilation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332074448.3722.25.camel@edumazet-laptop>
References: <1331992184.2466.45.camel@edumazet-laptop>
	<9a0230cb8db556cc9cf5d1f6b2439fb5.squirrel@webmail.greenhost.nl>
	<1332074448.3722.25.camel@edumazet-laptop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 19 Mar 2012 14:42:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 18 Mar 2012 05:40:48 -0700

> [PATCH] net: bpf_jit: fix BPF_S_LDX_B_MSH compilation
> 
> Matt Evans spotted that x86 bpf_jit was incorrectly handling negative
> constant offsets in BPF_S_LDX_B_MSH instruction.
> 
> We need to abort JIT compilation like we do in common_load so that
> filter uses the interpreter code and can call __load_pointer()
> 
> Reference: http://lists.openwall.net/netdev/2011/07/19/11
> 
> Thanks to Indan Zupancic to bring back this issue.
> 
> Reported-by: Matt Evans <matt@ozlabs.org>
> Reported-by: Indan Zupancic <indan@nul.nu>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied and even though libpcap won't generate this I'll queue it up
to -stable anyways.
