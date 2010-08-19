Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab0HSUaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:30:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60836 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab0HSUaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:30:17 -0400
Message-Id: <20100819201317.673172547@chello.nl>
User-Agent: quilt/0.47-1
Date: Thu, 19 Aug 2010 22:13:17 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <rmk@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 0/6] mm, highmem: kmap_atomic rework
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch-set reworks the kmap_atomic API to be a stack based, instead of
static slot based. Some might remember this from last year, some not ;-)

The advantage is that you no longer need to worry about KM_foo, the
disadvantage is that kmap_atomic/kunmap_atomic now needs to be strictly
nested (CONFIG_HIGHMEM_DEBUG should complain in case its not) -- and of
course its a big massive patch changing a widely used API.

The patch-set is currently based on tip/master as of today, and compile
tested on: i386-all{mod,yes}config, mips-yosemite_defconfig,
sparc-sparc32_defconfig, powerpc-ppc6xx_defconfig, and some arm config.

(Sorry dhowells, I again couldn't find frv/mn10300 compilers)

Boot tested with i386-defconfig on kvm.

Since its a rather large set, and somewhat tedious to rebase, I wanted to
ask how to go about getting this merged?

