Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab1CQPQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:16:09 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:46552 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752955Ab1CQPQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:16:07 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _nX_6awVM1lnB_E8VxV2d0L4HGdt47JmPm9Ew_UGUxJoO8x
 cWIhG1JSgwDxAT_X2bfhS4eOYmYum8rsZPw_wA9pAHqBWUZtZbMWeUV15AJT
 UMy_zzyCoIKDXv3xYu5dt9W9D1YlDGVqLzKrWKqBJDwunZNsBx5s97siEDBE
 WVNr54XmpsXX1gWkssyjvFMsGuP1eKoKsIh4z6tt8m6930Mt_KCcxXth3H_4
 .Nf8vSfhKDusUM0UzG93kEj7BMG4v7lEIT_OWroyakJ4M0VWHpNpjSu6xJ.w
 sHYwRu5MBS16o_VXnHNJU1A3fsSZdUC.nqFz7ws7hVpIYD2RL
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 17 Mar 2011 10:16:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Hugh Dickins <hughd@google.com>
cc: Pekka Enberg <penberg@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] slub,rcu: don't assume the size of struct rcu_head
In-Reply-To: <AANLkTikk02f6kLiPFqqAGroJErQkHbJFfHzpHy4Y5P8Y@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103171006270.12540@router.home>
References: <4D6CA852.3060303@cn.fujitsu.com> <AANLkTimXy2Yaj+NTDMNTWuLqHHfKZJhVDpeXj3CfMvBf@mail.gmail.com> <alpine.DEB.2.00.1103010909320.6253@router.home> <AANLkTim0Zjc7c9-7LCnEaYpV5PVN=5fNQpjMYqtZe-fk@mail.gmail.com> <alpine.DEB.2.00.1103020625290.10180@router.home>
 <AANLkTikk02f6kLiPFqqAGroJErQkHbJFfHzpHy4Y5P8Y@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Mar 2011, Hugh Dickins wrote:

> >> That was so for a long time, but I stopped it just over a year ago
> >> with commit a70caa8ba48f21f46d3b4e71b6b8d14080bbd57a, stop ptlock
> >> enlarging struct page.
> >
> > Strange. I just played around with in in January and the page struct size
> > changes when I build kernels with full debugging. I have some
> > cmpxchg_double patches here that depend on certain alignment in the page
> > struct. Debugging causes all that stuff to get out of whack so that I had
> > to do some special patches to make sure fields following the spinlock are
> > properly aligned when the sizes change.
>
> That puzzles me, it's not my experience and I don't have an
> explanation: do you have time to investigate?
>
> Uh oh, you're going to tell me you're working on an out-of-tree
> architecture with a million cpus ;)  In that case, yes, I'm afraid
> I'll have to update the SPLIT_PTLOCK_CPUS defaulting (for a million -
> 1 even).

No I am not working on any out of tree structure. Just regular dual socket
server boxes with 24 processors (which is a normal business machine
configuration these days).

But then there is also CONFIG_GENERIC_LOCKBREAK. That does not affect
things?

