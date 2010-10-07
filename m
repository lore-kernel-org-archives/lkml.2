Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687Ab0JGPLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:11:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58863 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab0JGPLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:11:34 -0400
Date: Thu, 7 Oct 2010 17:11:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, fweisbec@gmail.com,
        robert.richter@amd.com, gorcunov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] arch generic way to trigger unknown NMIs
Message-ID: <20101007151128.GC6270@basil.fritz.box>
References: <20101007030807.GA4076@redhat.com>
 <20101007072641.GE5010@basil.fritz.box>
 <20101007140112.GN10663@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007140112.GN10663@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 10:01:12AM -0400, Don Zickus wrote:
> On Thu, Oct 07, 2010 at 09:26:41AM +0200, Andi Kleen wrote:
> > 
> > Having a regression test for this is good, but it would 
> > be also good if it wasn't a private one but in some public
> > git repository.
> 
> Yeah, I know.  It isn't meant to be private, mostly glue logic to load
> this module using RedHat's internal test harness.
> 
> Is there a more public place to add a test like this?  I guess that would
> be LTP.  Though last time I looked at LTP, all the tests are written in
> 'C' whereas I just cobbled together some shell scripts to configure kdump,
> load the module, panic, process the resulting vmcore to verify it panic'd
> for the right reason

One possible place would be mce-test, but LTP would work too I guess.

> 
> > 
> > >  static struct jprobe lkdtm;
> > > @@ -340,6 +343,9 @@ static void lkdtm_do_action(enum ctype which)
> > >  		set_current_state(TASK_UNINTERRUPTIBLE);
> > >  		schedule();
> > >  		break;
> > > +	case NMI:
> > > +		apic->send_IPI_allbutself(NMI_VECTOR);
> > > +		break;
> > >  	case NONE:
> > >  	default:
> > >  		break;
> > > 
> > > Anyone have any thoughts?  Maybe there is an easier way?
> > 
> > Do you really want the NMI on all CPUs - 1? Normally it's directed to
> > a single one.
> 
> No I prefer a single one too, but there didn't seem to be a
> send_IPI_self() command, so I took the short route and sent it to
> everyone. :-(

You're not sending it to everyone, everyone but you.

Anyways for standard APIC send_IPI_cpu should be easy enough
to add. Standard NMI is usually to CPU #0 only.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
