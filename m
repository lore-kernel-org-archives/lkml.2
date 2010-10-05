Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab0JEUXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:23:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753199Ab0JEUXg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:23:36 -0400
MIME-Version: 1.0
In-Reply-To: <20101005191223.GA31795@elte.hu>
References: <20101005191223.GA31795@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Oct 2010 13:15:02 -0700
Message-ID: <AANLkTik9E0dr=Qah0d_+9YaAsA7WfeawA1c4oDbiJK-j@mail.gmail.com>
Subject: Re: [GIT PULL] core kernel fixes
To: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 12:12 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  #define rcu_dereference_bh(p) \
> -               rcu_dereference_check(p, rcu_read_lock_bh_held())
> +               rcu_dereference_check(p, rcu_read_lock_bh_held() || irqs_disabled())

Wouldn't that irqs_disabled() check have made more sense inside
rcu_read_lock_bh_held()?

That's the function that is _supposed_ to check whether bottom halves
are disabled, no? So why add a workaround for that function being
buggy/incomplete in one place that uses it?

                    Linus
