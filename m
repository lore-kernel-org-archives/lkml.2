Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab0FWAR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 20:17:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031Ab0FWAR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 20:17:28 -0400
Date: Tue, 22 Jun 2010 17:16:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?Q?=CE=91=CE=BB=CE=AD=CE=BE=CE=B1=CE=BD=CE=B4=CF=81=CE=BF=CF=82?=
	 =?UTF-8?Q?_=CE=A0=CE=B1=CF=80=CE=B1=CE=B4=CE=BF=CE=B3=CE=B9=CE=B1=CE=BD?=
	 =?UTF-8?Q?=CE=BD=CE=AC=CE=BA=CE=B7=CF=82?= <psxlover@hotmail.com>
Cc: <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: FW: sched_setaffinity not working with kernel 2.6.32.15
Message-Id: <20100622171622.fc9d04c1.akpm@linux-foundation.org>
In-Reply-To: <COL124-W1850C30E9FF3BFB06DF5BFD6C20@phx.gbl>
References: <COL124-W1850C30E9FF3BFB06DF5BFD6C20@phx.gbl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010 22:10:18 +0300
____________________ ______________________________  <psxlover@hotmail.com> wrote:

> 
> From: psxlover@hotmail.com
> To: mingo@elte.hu; peterz@infradead.org
> Subject:
>  sched_setaffinity not working with kernel 2.6.32.15
> Date: Sun, 20 
> Jun 2010 17:14:12 +0300

I assume from this that you initially sent the email privately to
Peter&Ingo, then forwarded it to the list without cc'ing Peter&Ingo. 
So if they're already responded to the inital email, I'm wasting my
time.  Ho hum.

> ...

That's a great bug report - fully bisected and it includes a testcase. 
Thanks.

However I think your testcase is buggy.  You have main() racing against
print_affinity().  If a sub-thread runs print_affinity() before main()
has run set_threadaffinity(), print_affinity() will obviously print
main()'s affinity.

Between 2.6.18 and 2.6.35-rc3 the timing changed a bit - in the later
kernel the sub-threads are running before main() is able to change
their affinity.  In the earlier kernel the sub-threads run first.

In both kernels, all CPU consumption is on CPU 0 as desired.

Re-enabling the sleep(1) in threadCode() fixes the print_affinity()
output, confirming that it's a userspace race.

