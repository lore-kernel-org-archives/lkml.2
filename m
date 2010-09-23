Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab0IWNOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 09:14:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54627 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab0IWNOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 09:14:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH tip/core/rcu 5/8] rcu: only one evaluation of arg in rcu_dereference_check() unless sparse
Date: Thu, 23 Sep 2010 15:13:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
References: <20100923005033.GA22006@linux.vnet.ibm.com> <1285203053-22068-5-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1285203053-22068-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009231513.40126.arnd@arndb.de>
X-Provags-ID: V02:K0:e6bPm5JFFuhmnvfB1KRXwoQ/FMQ1gGFjHaKOVGaW+it
 QJqGIrk2iPCDbyHgsV302n51iR9nZXTw8t4EJ07J8GWb+7LKEv
 pD90i1LuJfh61oGvVUWtD+4IQYnhkcPjjjyyoInEIM+u7nda36
 E6ov6NITkCOtZ9x3bnoRfy+mOJf+1DE2rZRR4y2tFkSwRVKM7c
 fUPWg+gvFzmxBn4rfBK5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 September 2010, Paul E. McKenney wrote:
> The current version of the __rcu_access_pointer(), __rcu_dereference_check(),
> and __rcu_dereference_protected() macros evaluate their "p" argument
> three times, not counting typeof()s.  This is bad news if that argument
> contains a side effect.  This commit therefore evaluates this argument
> only once in normal kernel builds.  However, the straightforward approach
> defeats sparse's RCU-pointer checking, so when __CHECKER__ is defined,
> the additional pair of evaluations of the "p" argument are performed in
> order to permit sparse to detect misuse of RCU-protected pointers.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Arnd Bergmann <arnd@arndb.de>

Sorry for not following up with the alternative approach yet. We can always
do that later, for your patch should go into 2.6.36 to fix any problems
arising from unintended macro side-effects.

Acked-by: Arnd Bergmann <arnd@arndb.de>
