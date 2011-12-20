Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1LTQtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 11:49:55 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:39363 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514Ab1LTQtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 11:49:50 -0500
X-Sasl-enc: Zqd2vypncXTi+kHPBLWpCeIr4muFDziuQ7GUqQVyTJ2j 1324399789
Subject: Re: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, LKML <linux-kernel@vger.kernel.org>,
        alan@lxorguk.ukuu.org.uk, morgan@kernel.org, luto@mit.edu,
        kzak@redhat.com, Steve Grubb <sgrubb@redhat.com>
In-Reply-To: <m1r500j4q0.fsf@fess.ebiederm.org>
References: <1323280461.10724.13.camel@lenny>
	 <20111210052945.GA14931@hallyn.com> <1323708089.29338.39.camel@lenny>
	 <20111212231149.GA16408@hallyn.com> <1323982580.31563.15.camel@lenny>
	 <m1k45xyreb.fsf@fess.ebiederm.org> <1324224103.21713.26.camel@lenny>
	 <m1ehw1mlcf.fsf@fess.ebiederm.org> <20111219040604.GA2205@hallyn.com>
	 <m1r500j4q0.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Dec 2011 11:49:23 -0500
Message-ID: <1324399763.25566.15.camel@lenny>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-19 at 01:22 -0800, Eric W. Biederman wrote:
> "
> As long as Colin only cares about being able to be the root user I
> agree.  

I don't actually need "pretend to be uid 0" functionality myself, but
the "fakeroot" case was cited on the user namespace page, and so I
wanted to understand how it works.

> If Colin needs several uids during his build that is trickier.
> But it sounds like Colin just needs to have a chroot build environment and
> for that a single user sounds good enough.

Right, just need chroot (and bind mounts).

> Being able to use the other namespaces to get a good isolation from the
> host environment is also nice and especially the pid namespace can
> guarantee that processes won't escape his build environment.

Yeah, CLONE_NEWPID is great.

> It is one of those worse is better implementation details but we can
> discuss that more when I start posting patches in January. 
> 
> I am not an immediate fan of writing random uids to disk.  Uids being
> persistent can be interesting to deal with if those uids are ever
> reused.

Right...

> Right now my implementation supports just 5 non-overlapping uid mapping
> ranges.  Which is enough to cover a lot of uids but still fit within one
> cacheline.  And I think to keep stat reasonable fast I want at to fit in
> a cacheline at least for now.  Oy.  Hopefully it isn't too hard to find
> some benchmarks to prove this out.  I expect the torture case is to
> time ls -l in a huge directory with a lot of files, owned by a lot of
> different users.

Where's the current user namespace tree?  The link on
https://wiki.ubuntu.com/UserNamespace is broken.

Is it:
http://kernel.ubuntu.com/git?p=serge/linux-2.6.git;a=summary

?

