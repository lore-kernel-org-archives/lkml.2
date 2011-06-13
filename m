Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1FMSAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:00:06 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:43110 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753601Ab1FMSAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:00:02 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: nO0Zo.4VM1kcHBkhCwYKPQxAYqCYcORLGuyJAC_b1G6v8kn
 B200xxj1g_AnF..lsmuNjS6zL4X_w8nGIvcNrPrXqKHyjqQhf5_7imEYZrsJ
 5osjj.Gcr4zWDCIZFAbQv2jBUIqUS4uOth3UoKKs4WNDX6MkK50vBUVy55pd
 IIGEEWCPm_zg_OHnEmjq5AvbK7HFj3QYaDIqx0c0GD89QbXAJSjeDMF7qQNr
 IqhPwve73CZ5QnERofVInodTfoH.nrHPc45c1QxDZ1jYx2WkWe9QHuHL4XPR
 WAyrsltRs0u1vI4.tM5Lll9ym.g7hON35TEwWq96luqpye91bIcoEaO7xtP7
 M96AH.l.Z2vRFGuW8lCltE5Nt
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 13 Jun 2011 12:59:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] slub: fix kernel BUG at mm/slub.c:1950!
In-Reply-To: <alpine.LSU.2.00.1106121842250.31463@sister.anvils>
Message-ID: <alpine.DEB.2.00.1106131258300.3108@router.home>
References: <alpine.LSU.2.00.1106121842250.31463@sister.anvils>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jun 2011, Hugh Dickins wrote:

> 3.0-rc won't boot with SLUB on my PowerPC G5: kernel BUG at mm/slub.c:1950!
> Bisected to 1759415e630e "slub: Remove CONFIG_CMPXCHG_LOCAL ifdeffery".
>
> After giving myself a medal for finding the BUG on line 1950 of mm/slub.c
> (it's actually the
> 	VM_BUG_ON((unsigned long)(&pcp1) % (2 * sizeof(pcp1)));
> on line 268 of the morass that is include/linux/percpu.h)
> I tried the following alignment patch and found it to work.

Hmmm.. The allocpercpu in alloc_kmem_cache_cpus should take care of the
alignment. Uhh.. I see that a patch that removes the #ifdef CMPXCHG_LOCAL
was not applied? Pekka?


