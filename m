Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1JZGYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 02:24:24 -0400
Received: from mail.openrapids.net ([64.15.138.104]:41648 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754009Ab1JZGYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 02:24:23 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 02:24:23 EDT
Date: Wed, 26 Oct 2011 02:15:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Roland Vossen <rvossen@broadcom.com>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
	built in-tree
Message-ID: <20111026061521.GB16408@Krystal>
References: <1319461948.31243.31.camel@deadeye> <4EA57CBF.2050901@xenotime.net> <87k47tpvvm.fsf@rustcorp.com.au> <20111025153855.GA24779@elliptictech.com> <1319558749.11727.6.camel@deadeye> <20111025165142.GA25354@elliptictech.com> <20111025200455.GA6376@kroah.com> <20111025201723.GA25063@redhat.com> <87zkgoo09f.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <87zkgoo09f.fsf@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 02:03:09 up 566 days, 15:52,  3 users,  load average: 1.03, 0.58,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Tue, 25 Oct 2011 16:17:24 -0400, Dave Jones <davej@redhat.com> wrote:
> > commit 7816c45bf13255157c00fb8aca86cb64d825e878
> > Author: Roland Vossen <rvossen@broadcom.com>
> > Date:   Thu Apr 7 11:20:58 2011 +0200
> > 
> >     modules: Enabled dynamic debugging for staging modules
> ...
> >     
> >     Signed-off-by: Roland Vossen <rvossen@broadcom.com>
> >     Acked-by: Jason Baron <jbaron@redhat.com>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Greg, you know better.  This is why we have maintainers: I can't track
> patches I don't see.  Grrr...
> 
> > If we want to support out of tree modules with this, should we just nuke the
> > whole check, or do we still want to prevent certain types of tainted kernels
> > from using this stuff ?
> 
> It goes back to the first implementation of kernel markers.  IIRC, it
> was to prevent dynamic debug stuff from circumventing licensing, but
> testing for *any* taint seems overbroad.  Mathieu?

This check for tainted modules was first introduced with markers, and
then used by tracepoints, and then also by dynamic debug. The rationale
for this check was mainly to ensure that the marker/tracepoint code
would not trigger a crash when loading a module with incompatible module
header, originally compiled for an older kernel, into a newer kernel.
This problem would happen even if the said module does not contain any
marker/tracepoint, because we happen to try to use fields that are
non-existent in the module header.

AFAIK, dynamic debug use a similar trick that require extra members in
the module header, so checking that the module header format is
compatible with the kernel would be enough. Is there a taint flag that
allows us to check for this more narrowly ? TAINT_FORCED_MODULE would
probably be the closest one we have now, although we might want to be
more specific than that.

Thanks,

Mathieu

> 
> Thanks,
> Rusty.
> PS.  Can't see how this related to lockdep either...

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
