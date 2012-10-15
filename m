Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab2JOUvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:51:15 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58166 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2JOUvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:51:13 -0400
Date: Mon, 15 Oct 2012 13:51:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ralf Baechle <ralf@linux-mips.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-mips@linux-mips.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] mm: huge_memory: Fix build error.
In-Reply-To: <20121015114456.GA30314@linux-mips.org>
Message-ID: <alpine.DEB.2.00.1210151349560.17947@chino.kir.corp.google.com>
References: <20121015114456.GA30314@linux-mips.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012, Ralf Baechle wrote:

> Certain configurations won't implicitly pull in <linux/pagemap.h> resulting
> in the following build error:
> 
> mm/huge_memory.c: In function 'release_pte_page':
> mm/huge_memory.c:1697:2: error: implicit declaration of function 'unlock_page' [-Werror=implicit-function-declaration]
> mm/huge_memory.c: In function '__collapse_huge_page_isolate':
> mm/huge_memory.c:1757:3: error: implicit declaration of function 'trylock_page' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> 

This is because CONFIG_HUGETLB_PAGE=n so mempolicy.h doesn't include 
pagemap.h?

> Reported-by: David Daney <david.daney@cavium.com>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Acked-by: David Rientjes <rientjes@google.com>
