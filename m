Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab1DFTQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab1DFTQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:16:07 -0400
Date: Wed, 6 Apr 2011 15:16:00 -0400
From: Jason Baron <jbaron@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Roland Vossen <rvossen@broadcom.com>,
        devel <devel@linuxdriverproject.org>
Subject: Re: [Fwd: Fwd: Re: Why is dynamic debug disabled for staging drivers
 ?]
Message-ID: <20110406191559.GB6981@redhat.com>
References: <1302104075.1683.46.camel@Joe-Laptop>
 <20110406184158.GA6981@redhat.com>
 <20110406185525.GA12915@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406185525.GA12915@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 11:55:25AM -0700, Greg KH wrote:
> On Wed, Apr 06, 2011 at 02:41:59PM -0400, Jason Baron wrote:
> > The concern I would have in allowing tainted modules is that we are
> > relying on a specific format for the dynamic debug section in the
> > compiled module. For example, if a module was built with a format with an old
> > section, we could potentially get confused. This can be solved with
> > versioning, but that adds extra complexity. We can of course also make
> > sure we don't change the format...
> 
> I wouldn't worry about that at all.  If you try to load a kernel module
> that was not built against the kernel you are running, all bets are off
> and lots of bad things can happen in other areas.
> 
> > Notice that tracepoints, which also rely on a specific module format,
> > also employ a taint flag check.
> 
> Ok, but TAINT_CRAP shouldn't be part of that check, right?
> 

Right, allowing -staging drivers (which are part of the kernel tree) to
make use of dynamic debug facility seems reasonable.

thanks,

-Jason
