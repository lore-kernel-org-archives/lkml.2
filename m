Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab1KVOuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:50:14 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:33652 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753364Ab1KVOuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:50:07 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Jw5AcfsVM1mfeK3EQzJjiMnSzItfqTW5JLX698mlvKg1oaH
 eu.67rLNvyZyXtbN4NZ8NE6M7b3_tl2kTZoZskYi1NLqZe6z9vkJ9jYfh8rX
 mA1XttUCZS4eBTwcNbuLVrNJD7uQQVcyyh1Sd.BWxHMGfOoUPG.wcY8TrLKl
 usVPg8BUee.FWwO1bh8t6m1nnS1fM7Ko7WRQi2EYbJK8G7HDJkrc9gvKMiWe
 KCIt3QknWOO7b9o6Epk510jH9VLvGm9rDZi2kheQhC5itakheLvEgAQ1WYdE
 n72Saf3ZVj8_.zDL3ke57vhlLI0SJKQdQabHagYu8ojjz0y2XYV7Mpo9ied5
 6zotvWUPyrAL.VL0O3TNsQPcSqFHMAQKLHT5ozgjA0nf0R_fDbFcgSr_gpnO
 CEUcx5HcoGQQwo1LBMye6KA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 08:50:03 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
In-Reply-To: <20111122112107.GA1675@x4.trippels.de>
Message-ID: <alpine.DEB.2.00.1111220846570.25785@router.home>
References: <1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20111121173556.GA1673@x4.trippels.de> <1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20111121185215.GA1673@x4.trippels.de> <20111121195113.GA1678@x4.trippels.de>
 <1321907275.13860.12.camel@pasglop> <alpine.DEB.2.01.1111211617220.8000@trent.utfs.org> <alpine.DEB.2.00.1111212105330.19606@router.home> <20111122084513.GA1688@x4.trippels.de> <1321954729.2474.4.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20111122112107.GA1675@x4.trippels.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Markus Trippelsdorf wrote:

> > Given slub is now lockless, validate_slab_slab() is probably very wrong
> > these days.
>
> OK "slabinfo -v" is useless then. But that doesn't invalidate the BUGs
> that I saw during boot. They happend before I could even run slabinfo
> for the first time.

Correct. Also the use of debugging disables the use of cmpxchg_double()
but not this_cpu_cmpxchg() use. See cmpxchg_double_slab() and
kmem_cache_open()s determination of the __CMPXCHG_DOUBLE flag.

