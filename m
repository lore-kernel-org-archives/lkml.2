Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab1BHNoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:44:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:40656 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1BHNoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:44:38 -0500
Subject: Re: RFC: /proc/<pid>/sched should contain cumulative data for all
 threads in process
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Friesen <chris.friesen@genband.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110208121144.GA7550@elte.hu>
References: <4D50723B.7020400@genband.com>
	 <1297156865.13327.57.camel@laptop>  <20110208121144.GA7550@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 14:45:42 +0100
Message-ID: <1297172742.13327.102.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 13:11 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Mon, 2011-02-07 at 16:29 -0600, Chris Friesen wrote:
> > > Hi,
> > > 
> > > We've got a tool that gathers lots of scheduling data for each process
> > > (not task/thread) on the system.
> > > 
> > > For /proc/<pid>/{stat,io} this is straightforward, as the per-thread
> > > values are summed together for the process as a whole.
> > > 
> > > However, /proc/<pid>/sched only shows the data for the individual thread
> > > with the same tid as the pid.  To get a per-process view we need to
> > > manually scan all the threads and sum them--and this can get expensive
> > > due to all the extra file operations, parsing, etc.
> > > 
> > > Was this a concious design decision, or just an oversight?  Would a
> > > patch converting it to whole-process values be accepted or is it enough
> > > of a standard interface that we can't break existing apps that expect
> > > the current behaviour?
> > 
> > I'd as soon remove all that stuff than extend it, its an abi liability,
> > esp since you're talking about tools parsing this stuff.
> 
> So assuming a tool would want to capture such stats of the system, what would be its 
> options? Could we do all this via system-wide counters and perf stat alike cheap, 
> transparent gathering without having to patch/rebuild the kernel?

Very much depends on what is wanted, but most of the stuff inside those
files is very specific to the implementation and pinning any of that to
an ABI is like silly.

