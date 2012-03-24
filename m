Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2CXCAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 22:00:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33478 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab2CXCAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 22:00:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120324014755.GA4685@linux.vnet.ibm.com>
References: <20120319152317.GA3932@gmail.com> <CA+55aFyezw6yW2g6hOAOeZ5vRm0xUNPQyD4eo0wRHMHiN3Z+kQ@mail.gmail.com>
 <20120320033300.GH2393@linux.vnet.ibm.com> <CA+55aFzXAdNRqNHm3-wx02au4b_Ze_WM-gCtOk+gJdGMsn3Zbg@mail.gmail.com>
 <20120323192143.GY2450@linux.vnet.ibm.com> <CA+55aFzgno-7AcHxKMWGYrr2QAwEzXOieSghnsEfPQJ5aed-yQ@mail.gmail.com>
 <20120323211638.GA2450@linux.vnet.ibm.com> <20120323212550.GA11791@linux.vnet.ibm.com>
 <20120324014755.GA4685@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Mar 2012 19:00:28 -0700
X-Google-Sender-Auth: f_A4MX-KetdQLWiVKAQQMcwvGvM
Message-ID: <CA+55aFwgnhhoV=9PT3N0YToEwKDUB6pqOQhX3+6o3CeccC10=g@mail.gmail.com>
Subject: Re: [GIT PULL] RCU changes for v3.4
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 6:47 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> This is what I get on a 32-bit build, according to objdump:
>
>        24e3:       64 ff 05 00 00 00 00    incl   %fs:0x0

You do? I'm surprised:

> +static inline void __rcu_read_lock(void)
> +{
> +       __raw_get_cpu_var(rcu_read_lock_nesting)++;
> +       barrier(); /* Keep code within RCU read-side critical section. */
> +}

This looks wrong.

It should use "this_cpu_inc(rcu_read_lock_nesting)", I don't even see
how you get gcc to generate that "inc %fs:" without it.

In general, I don't think you should ever use the __raw_get_cpu_var() things.

                      Linus
