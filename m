Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab1JDOua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:50:30 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:25052 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932141Ab1JDOu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:50:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Um4QIsIVM1l0sQtNL_Y1NdGrwYRY1vyINSSQzHoL4NCEH9B
 7wyN9Dm2HoRGif.0k3H5XyfZlBvAIkcL5F5QlRYYmrqA_X1BkM5NbQ57PijW
 o8ZngrI8w63xaNwlMp5adv9TNTpotLx9OoVemW6h2ha.aidYq_fOZaJ8.e6C
 HikNr6.juwaLy0dqFLesVOmtjn3_b2pRQg_5gN8ijOFFQpKS81xYRFUluQoW
 S0TAYOlE5t58LMr1cbqYC4JazP_70JoxC7geB_agUMt6oEGXW57LTy3SxDKu
 n16wpiKAiS7CpVcPKGBhQ_2Sf5jbzr9Tkap28w6cj5Ct_zwbOc3AzX1cySXG
 0IbXz3gYLjIklsHNWJe2ya.iK9nzIEmQnsSCY7oAjlVz4x_Pt1sFckdiBTk9
 nPxvmcjS_.OIFCyfjN4raKk4-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 4 Oct 2011 09:50:25 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, penberg@kernel.org, mpm@selenic.com,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>
Subject: Re: lockdep recursive locking detected (rcu_kthread /
 __cache_free)
In-Reply-To: <1317739225.32543.9.camel@twins>
Message-ID: <alpine.DEB.2.00.1110040948230.8522@router.home>
References: <20111003175322.GA26122@sucs.org>  <20111003203139.GH2403@linux.vnet.ibm.com>  <alpine.DEB.2.00.1110031540560.11713@router.home>  <20111003214739.GK2403@linux.vnet.ibm.com>  <alpine.DEB.2.00.1110040916330.8522@router.home>
 <1317739225.32543.9.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Oct 2011, Peter Zijlstra wrote:

> It could of course be I got confused and broke stuff instead, could
> someone who knows slab (I guess that's either Pekka, Christoph or David)
> stare at those patches?

Why is the loop in init_lock_keys only running over kmalloc caches and not
over all slab caches? It seems that this has to be especially applied to
regular slab caches because those are the ones that mostly have off slab
structures. So modify init_lock_keys to run over all slab caches?


