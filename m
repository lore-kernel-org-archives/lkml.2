Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab0JGPsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:48:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab0JGPsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:48:15 -0400
Date: Thu, 7 Oct 2010 11:47:58 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, fweisbec@gmail.com, robert.richter@amd.com,
        gorcunov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] arch generic way to trigger unknown NMIs
Message-ID: <20101007154758.GA22385@redhat.com>
References: <20101007030807.GA4076@redhat.com>
 <20101007072641.GE5010@basil.fritz.box>
 <20101007140112.GN10663@redhat.com>
 <20101007151128.GC6270@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007151128.GC6270@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 05:11:29PM +0200, Andi Kleen wrote:
> On Thu, Oct 07, 2010 at 10:01:12AM -0400, Don Zickus wrote:
> > On Thu, Oct 07, 2010 at 09:26:41AM +0200, Andi Kleen wrote:
> > > 
> > > Having a regression test for this is good, but it would 
> > > be also good if it wasn't a private one but in some public
> > > git repository.
> > 
> > Yeah, I know.  It isn't meant to be private, mostly glue logic to load
> > this module using RedHat's internal test harness.
> > 
> > Is there a more public place to add a test like this?  I guess that would
> > be LTP.  Though last time I looked at LTP, all the tests are written in
> > 'C' whereas I just cobbled together some shell scripts to configure kdump,
> > load the module, panic, process the resulting vmcore to verify it panic'd
> > for the right reason
> 
> One possible place would be mce-test, but LTP would work too I guess.

I forgot about mce-test.  I can look at that too.

<snip>

> > 
> > No I prefer a single one too, but there didn't seem to be a
> > send_IPI_self() command, so I took the short route and sent it to
> > everyone. :-(
> 
> You're not sending it to everyone, everyone but you.
> 
> Anyways for standard APIC send_IPI_cpu should be easy enough
> to add. Standard NMI is usually to CPU #0 only.

Would that still be x86 specific though?  I could probably code that up,
though I wonder if it would be accepted just for a test case.

Cheers,
Don
