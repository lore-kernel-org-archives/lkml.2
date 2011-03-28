Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab1C1WNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:13:06 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58844 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1C1WND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:13:03 -0400
Date: Mon, 28 Mar 2011 15:12:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Will Newton <will.newton@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: advice sought: practicality of SMP cache coherency implemented
 in assembler (and a hardware detect line)
Message-ID: <20110328221257.GP2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
 <AANLkTi=W0mW2o2muNgMnb1OQ6WaBeOmu1VBHr8Zf63r9@mail.gmail.com>
 <20110326120847.71b6ae4d@lxorguk.ukuu.org.uk>
 <20110328180655.GI2287@linux.vnet.ibm.com>
 <AANLkTin6kg84P50RHR7h6NG+P_nJK=N_Nefc1q4NxzY_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin6kg84P50RHR7h6NG+P_nJK=N_Nefc1q4NxzY_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 07:48:34PM +0100, Luke Kenneth Casson Leighton wrote:
> On Mon, Mar 28, 2011 at 7:06 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >> Basically it would become a cluster with a very very fast "page transfer"
> >> operation for moving data between nodes.
> >
> > This works for applications coded specially for this platform, but unless
> > I am missing something, not for existing pthreads applications.  Might
> > be able to handle things like Erlang that do parallelism without shared
> > memory.
> 
>  ok - well, having thought about this a little bit (in a non-detailed
> high-level way) i was sort-of hoping, as alan hinted at, to still do
> SMP, even if it's slow, for userspace.   the primary thing to prevent
> from happening is to have kernelspace data structures from
> conflicting.
> 
>  i found kerrigan, btw, spoke to the people on it: louis agreed that
> the whole idea was mad as hell and was therefore actually very
> interesting to attempt :)

What was that old Chinese curse?  "May you live in interesting times"
or something like that?  ;-)

I suspect that you can get something that runs suboptimally but mostly
works.  Getting something that really works likely requires that the
hardware support cache coherence.

>  as a first approximation i'm absolutely happy for existing pthreads
> applications to be forced to run on the same core.

In a past life, we forced any given pthread process to have all of
its threads confined to a single NUMA node, so I guess that there is
precedent.  The next step is figuring out how to identify apps that
use things like mmap() to share memory among otherwise unrelated
processes, and working out what to do with them.

							Thanx, Paul
