Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab0FWHT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 03:19:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0FWHTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 03:19:25 -0400
Subject: Re: FW: sched_setaffinity not working with kernel 2.6.32.15
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?=CE=91=CE=BB=CE=AD=CE=BE=CE=B1=CE=BD=CE=B4=CF=81=CE=BF=CF=82_?=
	 =?UTF-8?Q?=CE=A0=CE=B1=CF=80=CE=B1=CE=B4=CE=BF=CE=B3=CE=B9=CE=B1=CE=BD?=
	 =?UTF-8?Q?=CE=BD=CE=AC=CE=BA=CE=B7=CF=82?= <psxlover@hotmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100622171622.fc9d04c1.akpm@linux-foundation.org>
References: <COL124-W1850C30E9FF3BFB06DF5BFD6C20@phx.gbl>
	 <20100622171622.fc9d04c1.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Jun 2010 09:19:17 +0200
Message-ID: <1277277558.1875.745.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 17:16 -0700, Andrew Morton wrote:
> On Sun, 20 Jun 2010 22:10:18 +0300
> ____________________ ______________________________  <psxlover@hotmail.com> wrote:
> 
> > 
> > From: psxlover@hotmail.com
> > To: mingo@elte.hu; peterz@infradead.org
> > Subject:
> >  sched_setaffinity not working with kernel 2.6.32.15
> > Date: Sun, 20 
> > Jun 2010 17:14:12 +0300
> 
> I assume from this that you initially sent the email privately to
> Peter&Ingo, then forwarded it to the list without cc'ing Peter&Ingo. 
> So if they're already responded to the inital email, I'm wasting my
> time.  Ho hum.

My private copy seems to have gone missing..

> > ...
> 
> That's a great bug report - fully bisected and it includes a testcase. 
> Thanks.
> 
> However I think your testcase is buggy.  You have main() racing against
> print_affinity().  If a sub-thread runs print_affinity() before main()
> has run set_threadaffinity(), print_affinity() will obviously print
> main()'s affinity.
> 
> Between 2.6.18 and 2.6.35-rc3 the timing changed a bit - in the later
> kernel the sub-threads are running before main() is able to change
> their affinity.  In the earlier kernel the sub-threads run first.
> 
> In both kernels, all CPU consumption is on CPU 0 as desired.
> 
> Re-enabling the sleep(1) in threadCode() fixes the print_affinity()
> output, confirming that it's a userspace race.

Andrew is right, your program is buggy. 
