Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934255Ab0KQLRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 06:17:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:47250 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933515Ab0KQLRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 06:17:14 -0500
Message-ID: <4CE3B927.1020401@kernel.org>
Date: Wed, 17 Nov 2010 12:14:47 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dan Smith <danms@us.ibm.com>
CC: Gene Cooperman <gene@ccs.neu.edu>, Oren Laadan <orenl@cs.columbia.edu>,
        Kapil Arya <kapil@ccs.neu.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>	<4CD26948.7050009@kernel.org>	<20101104164401.GC10656@sundance.ccs.neu.edu>	<4CD3CE29.2010105@kernel.org>	<AANLkTimDXKsBCxbsEOfgkYV2R8FK=bhFdmx9UQow5hqp@mail.gmail.com>	<4CD5DCE3.3000109@cs.columbia.edu>	<20101107194222.GG31077@sundance.ccs.neu.edu>	<4CD71A6B.3020905@cs.columbia.edu>	<20101107230516.GJ31077@sundance.ccs.neu.edu>	<4CD774CA.8030004@cs.columbia.edu>	<20101108162630.GN31077@sundance.ccs.neu.edu> <8739rbpreb.fsf@localhost6.localdomain6>
In-Reply-To: <8739rbpreb.fsf@localhost6.localdomain6>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Nov 2010 11:14:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/08/2010 08:05 PM, Dan Smith wrote:
> GC> As before, Oren, let's have that phone discussion so that we can
> GC> preprocess a lot of this, instead of acting like the the three
> GC> blind men and the elephant.  I will _tell you_ the strengths and
> GC> weaknesses of DMTCP on the phone, instead of you having to guess
> GC> at them here on LKML.  And of course, I hope you will be similarly
> GC> frank about Linux C/R on the phone.
> 
> I want to be in on that discussion too, as do a lot of other people
> here.  However, I doubt we'll all be able to find a common spot on our
> collective schedules, nor would that conversation be archived for
> posterity.  I think sticking to LKML is the right (and time-tested)
> approach.

Amen.

> OL> Linux-cr can do live migration - e.g. VDI, move the desktop - in
> OL> which case skype's sockets' network stacks are reconstructed,
> OL> transparently to both skype (local apps) and the peer (remote
> OL> apps).  Then, at the destination host and skype continues to work.
> 
> GC> That's a really cool thing to do, and it's definitely not part of
> GC> what DMTCP does.  It might be possible to do userland live
> GC> migration, but it's definitely not part of our current scope.
> 
> How would you go about doing that in userland?  With the current
> linux-cr implementation, I can move something like sshd or sendmail
> from one machine to another without a remote (connected) client
> noticing anything more than a bit of delay during the move.
> 
> I think that saving and restoring the state of a TCP connection from
> userland is probably a good example of a case where it makes sense to
> have it as part of a C/R function, but not necessarily exposed in /sys
> or /proc somewhere.  Unless it can be argued that doing so is not
> useful, I think that's a good talking point for discussing the kernel
> vs. user approach, no?

Meh, just implementing a conntrack module should be good enough for
most use cases.  If it ever becomes a general enough problem (which I
extremely strongly doubt), we can think about allowing processes in a
netns to change sequence number but that would be a single setsockopt
option instead of the horror show of dumping in-kernel data structures
in binary blob.

Thanks.

-- 
tejun
