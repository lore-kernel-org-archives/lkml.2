Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab1JCUqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:46:22 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:44504 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932195Ab1JCUqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:46:15 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: NnligPQVM1nm._cO6bZUtUwkHhreEN.ZPzV9ygS.9V7qKww
 VgA.KEcbJIHT6ccY5No3QKfvPqVpxYlKGBa1BMq05mPYVoTr_7sPeXff8Mpq
 LmtrVVfQYYxHJfonNkx_TldTyqJXtKAfVwQy1AhEbIO6wRFDvfWTGOlC_tI3
 fJvf_e6nW3hKEmNu7j2tkDi16n4iTHJHTfM4W5wIVE9AvA1QD6GyMBOqfuSx
 KrgPCdF11PG8NcQALmPT9jq_j4ND9GIzhVD77IfMD2U0SYz7KfRHyeuT.8tM
 r.IEipfm2MZKWVf0q.qwCk5pY77S1q29ejemXPq3E41fji00onUio_HjIlKV
 L6oZ3OCtAR9SNSXqotZxo2wTop9Iq8oSwt.GVaTizWAXoR3g1B8L_LPn5zt.
 DAm0YnTMcIMOLzf3rv0pUia4-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 3 Oct 2011 15:46:11 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        penberg@kernel.org, mpm@selenic.com, linux-mm@kvack.org
Subject: Re: lockdep recursive locking detected (rcu_kthread /
 __cache_free)
In-Reply-To: <20111003203139.GH2403@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1110031540560.11713@router.home>
References: <20111003175322.GA26122@sucs.org> <20111003203139.GH2403@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Oct 2011, Paul E. McKenney wrote:

> The first lock was acquired here in an RCU callback.  The later lock that
> lockdep complained about appears to have been acquired from a recursive
> call to __cache_free(), with no help from RCU.  This looks to me like
> one of the issues that arise from the slab allocator using itself to
> allocate slab metadata.

Right. However, this is a false positive since the slab cache with
the metadata is different from the slab caches with the slab data. The slab
cache with the metadata does not use itself any metadata slab caches.

