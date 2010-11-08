Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0KHTd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:33:56 -0500
Received: from gw0.danplanet.com ([71.245.107.82]:53041 "EHLO
	mail.danplanet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752503Ab0KHTdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:33:55 -0500
X-Greylist: delayed 1684 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Nov 2010 14:33:55 EST
To: Gene Cooperman <gene@ccs.neu.edu>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Kapil Arya <kapil@ccs.neu.edu>,
        Tejun Heo <tj@kernel.org>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
	<4CD26948.7050009@kernel.org>
	<20101104164401.GC10656@sundance.ccs.neu.edu>
	<4CD3CE29.2010105@kernel.org>
	<AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>
	<4CD5DCE3.3000109@cs.columbia.edu>
	<20101107194222.GG31077@sundance.ccs.neu.edu>
	<4CD71A6B.3020905@cs.columbia.edu>
	<20101107230516.GJ31077@sundance.ccs.neu.edu>
	<4CD774CA.8030004@cs.columbia.edu>
	<20101108162630.GN31077@sundance.ccs.neu.edu>
From: Dan Smith <danms@us.ibm.com>
Date: Mon, 08 Nov 2010 11:05:48 -0800
In-Reply-To: <20101108162630.GN31077@sundance.ccs.neu.edu> (Gene Cooperman's message of "Mon\, 8 Nov 2010 11\:26\:30 -0500")
Message-ID: <8739rbpreb.fsf@localhost6.localdomain6>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GC> As before, Oren, let's have that phone discussion so that we can
GC> preprocess a lot of this, instead of acting like the the three
GC> blind men and the elephant.  I will _tell you_ the strengths and
GC> weaknesses of DMTCP on the phone, instead of you having to guess
GC> at them here on LKML.  And of course, I hope you will be similarly
GC> frank about Linux C/R on the phone.

I want to be in on that discussion too, as do a lot of other people
here.  However, I doubt we'll all be able to find a common spot on our
collective schedules, nor would that conversation be archived for
posterity.  I think sticking to LKML is the right (and time-tested)
approach.

OL> Linux-cr can do live migration - e.g. VDI, move the desktop - in
OL> which case skype's sockets' network stacks are reconstructed,
OL> transparently to both skype (local apps) and the peer (remote
OL> apps).  Then, at the destination host and skype continues to work.

GC> That's a really cool thing to do, and it's definitely not part of
GC> what DMTCP does.  It might be possible to do userland live
GC> migration, but it's definitely not part of our current scope.

How would you go about doing that in userland?  With the current
linux-cr implementation, I can move something like sshd or sendmail
from one machine to another without a remote (connected) client
noticing anything more than a bit of delay during the move.

I think that saving and restoring the state of a TCP connection from
userland is probably a good example of a case where it makes sense to
have it as part of a C/R function, but not necessarily exposed in /sys
or /proc somewhere.  Unless it can be argued that doing so is not
useful, I think that's a good talking point for discussing the kernel
vs. user approach, no?

-- 
Dan Smith
IBM Linux Technology Center
