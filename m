Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1DDPqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:46:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57834 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754628Ab1DDPqO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:46:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110402103125.GA18746@elte.hu>
References: <20110402103125.GA18746@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 4 Apr 2011 08:45:34 -0700
Message-ID: <BANLkTikZS8zZ-oRfBsriEnzp17VMwXAjSg@mail.gmail.com>
Subject: Re: [GIT PULL] scheduler fixes
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I pulled this, but I think this:

On Sat, Apr 2, 2011 at 3:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> -               if (interval > HZ*NR_CPUS/10)
> -                       interval = HZ*NR_CPUS/10;
> +               if (interval > HZ*num_online_cpus()/10)
> +                       interval = HZ*num_online_cpus()/10;

is a horrible patch.

Think about what that expands to. It's going to potentially be two
function calls. And the code is just ugly.

So please, when doing search-and-replace changes like this, just clean
up the code at the same time. Back when it was about pure constants,
there was only a typing/ugly overhead from duplicating the constant,
but the compiler would see a single constant.

Now it's _possible_ that the compiler could do the analysis and fold
it all back to a single thing. But it's unlikely to happen except for
configurations that end up making it all trivial.

So just add something like a

   int max_interval = HZ*num_online_cpus()/10;

possibly even with a comment about _why_ that is the max interval allowed.  Ok?

                        Linus
