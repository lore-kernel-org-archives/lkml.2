Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab2DNRJR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 13:09:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61753 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2DNRJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 13:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyR7Rt0-guH4TrrS83VQLsj-wrvQgOwvrf0UscRCxM-OA@mail.gmail.com>
References: <20120414161953.GA18140@linux.vnet.ibm.com> <CA+55aFyR7Rt0-guH4TrrS83VQLsj-wrvQgOwvrf0UscRCxM-OA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 10:08:54 -0700
X-Google-Sender-Auth: g-_Fa1_LtMUK7IMnsoAajaQo1R0
Message-ID: <CA+55aFzrmg2Fqg9VD9zV==gxiimW_By2zM17AvJXKY5ecX-ang@mail.gmail.com>
Subject: Re: [PATCH RFC 0/7] rcu: v2 Inlinable preemptible rcu_read_lock() and rcu_read_unlock()
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 9:58 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll see if it boots and what it does to my profiles and
> microbenchmark, though.

Ok, I can't see any performance difference in the numbers - my
benchmark noise is *much* bigger than anything this would show.

The profile looks fine, and obviously __rcu_read_lock() is entirely
gone. The top user (avc_has_perm_flags()) looks fine. I note that you
might want to look at the placement of the percpu data - I think it
probably makes sense to put the RCU data close to 'current' etc to get
as much cacheline sharing as possible, and it doesn't seem to be right
now, but it looks reasonable.

But on the whole, I can't claim that it looks noticeable ;*(

                   Linus
