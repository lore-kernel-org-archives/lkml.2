Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab1DDQ14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:27:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51713 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1DDQ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:27:55 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=wom5GMh1gUkA:10 a=qfFVHXmYx5UA:10 a=kj9zAlcOel0A:10 a=eAWTIsOZi86Vnn5xZOjC/w==:17 a=ybZZDoGAAAAA:8 a=HzlK4LP7ho-EwRXsU00A:9 a=DK8yuu_Wl3GhSpZlswEA:7 a=CjuIK1q_8ugA:10 a=qIVjreYYsbEA:10 a=gSakuyrkLxAQ2xSX:21 a=jhRHLAOjGmMhi6zC:21 a=eAWTIsOZi86Vnn5xZOjC/w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.154.172
Date: Mon, 4 Apr 2011 11:27:53 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Oren Laadan <orenl@cs.columbia.edu>, Andrew Morton <akpm@osdl.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
Message-ID: <20110404162753.GA3456@hallyn.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-6-git-send-email-ntl@pobox.com>
 <20110403190324.GD15044@hallyn.com>
 <1301929228.31531.39.camel@tp-t61>
 <20110404151017.GA4857@hallyn.com>
 <1301931608.31531.49.camel@tp-t61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301931608.31531.49.camel@tp-t61>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nathan Lynch (ntl@pobox.com):
> On Mon, 2011-04-04 at 10:10 -0500, Serge E. Hallyn wrote:
> > Quoting Nathan Lynch (ntl@pobox.com):
> > > On Sun, 2011-04-03 at 14:03 -0500, Serge E. Hallyn wrote:
> > > > Quoting ntl@pobox.com (ntl@pobox.com):
> > > > > Only a pid namespace init task - the child process produced by a call
> > > > > to clone(2) with CLONE_NEWPID - is allowed to call these.  The state
> > > > 
> > > > So you make this useful for your cases by only using this with
> > > > application containers - created using lxc-execute, or, more precisely,
> > > > using lxc-init as the container's init.  So a container running a stock
> > > > distro can't be checkpointed.
> > > 
> > > Correct, a conventional distro init won't work, and application
> > > containers are my focus for now, at least.
> > > 
> > > 
> > > > Is this just to keep the patch simple for now, or is there some reason
> > > > to keep this limitation in place?
> > > 
> > > I guess you're asking whether non-pid-init processes could be allowed to
> > > use the syscalls?
> > 
> > No.  I'm asking whether you are intending to later on change the checkpoint
> > API to allow an external task to checkpoint a pid-init process, rather than
> > the pid-init process having to initiate it itself.
> 
> No, that is not the intention.  I can see how that would be problematic
> for those wanting to run minimally-modified distro containers, but I
> think running a patched pid-init is a reasonable tradeoff to ask users
> to make in order to get c/r.  And there's nothing to keep the standard
> distro inits from growing c/r capability.

It's not necessarily a dealbreaker, since presumably I can hack the
needed support into upstart, triggered by a boot option so it isn't
activated on a host.  But especially given the lack of interest in
this thread so far, I don't see a point in pushing this, an API-incompatible
less-capable version of the linux-cr tree.  If it can gain traction
better than linux-cr, that'd be one thing.  But given the amount of
review and testing the other tree has gotten - and I realize you're
able to piggy-back on much of that - and, again, the lack of responses
so far, I just don't see this as worth pushing for.

I'd really prefer that everyone was using the same tree, and sending
any and all patches which they need, no matter how ugly they fear
they are, upstream.  To that end, I think it would be appropriate
for you or Dan to get write access to Oren's tree or to move to a
newly cloned copy of his tree to which one of you has acces.

Andrew (Cc:d), did you see this thread go by, and it did it look
in any way more palatable to you?  Have you had any thoughts on
checkpoint/restart in the last few months?  Or did that horse quietly
die over winter?

thanks,
-serge
