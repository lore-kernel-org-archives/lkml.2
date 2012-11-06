Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab2KFBZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 20:25:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51924 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256Ab2KFBZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 20:25:06 -0500
Date: Mon, 05 Nov 2012 20:25:01 -0500 (EST)
Message-Id: <20121105.202501.1246122770431623794.davem@davemloft.net>
To: walken@google.com
Cc: akpm@linux-foundation.org, riel@redhat.com, hughd@google.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        ralf@linux-mips.org, lethal@linux-sh.org, cmetcalf@tilera.com,
        x86@kernel.org, wli@holomorphy.com, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 15/16] mm: use vm_unmapped_area() on sparc32
 architecture
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352155633-8648-16-git-send-email-walken@google.com>
References: <1352155633-8648-1-git-send-email-walken@google.com>
	<1352155633-8648-16-git-send-email-walken@google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel Lespinasse <walken@google.com>
Date: Mon,  5 Nov 2012 14:47:12 -0800

> Update the sparc32 arch_get_unmapped_area function to make use of
> vm_unmapped_area() instead of implementing a brute force search.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

Hmmm...

> -	if (flags & MAP_SHARED)
> -		addr = COLOUR_ALIGN(addr);
> -	else
> -		addr = PAGE_ALIGN(addr);

What part of vm_unmapped_area() is going to duplicate this special
aligning logic we need on sparc?
