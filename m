Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1EXHDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:03:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33468 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab1EXHDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:03:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
References: <m11uzrvd26.fsf@fess.ebiederm.org>
	<BANLkTim4q5dK6nOb=pVKbk1c8b-Nh_hBfA@mail.gmail.com>
	<m1boyvpo9r.fsf@fess.ebiederm.org>
	<1306048393.4092.8.camel@mulgrave.site>
	<20110522084224.GA12279@elte.hu>
Date: Tue, 24 May 2011 00:03:37 -0700
In-Reply-To: <20110522084224.GA12279@elte.hu> (Ingo Molnar's message of "Sun,
	22 May 2011 10:42:24 +0200")
Message-ID: <m1k4dgr35i.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+zIpuocqRZvMIpKYZLPP35hqXduACm5bQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> I agree with Linus's notion in this thread though, a core kernel change should 
> generally not worry about hooking up rare-arch system calls (concentrate on the 
> architectures that get tested most) - those are better enabled gradually 
> anyway.

The way I read it he was complaining about my having parisc bits and
asking for my branch to be merged before the parisc bits had been
merged.  Which I credit as a fair complaint.  If I am going to depend on
other peoples trees I should wait.

At the same time when I am busy looking for every possible source of
trouble and putting code into net-next to detect pending conflicts,
and when maintainers complain when I ask for review that my patches
conflict with their patches.  Being a contentious developer I am
inclined to do something.

Now that the reality has sunk in that it means waiting for other peoples
code to be merged before I request for my changes to be merged I don't
think I will structure a tree that way again while I remember.

> Also, system call table conflicts are trivial to resolve. Merging in net-next 
> to avoid such a conflict is like cracking a nut with a sledgehammer.

Well I still have trauma from how nasty it was to test with syscall
numbers continuing to change when I was working on the kexec_load system
call.

As far as I can tell any one system call conflict on any one
architecture is easy to resolve.  Resolving a conflict on all
architectures would amount to at least 50 files that need to be resolved
that feels a bit more than trivial.

My gut feel says we should really implement an
include/asm-generic/unistd-common.h to include all new system calls.

That way there would be only one file to touch instead of 50.
Certainly it works for include/asm-generic/unistd.h for the
architectures that use it.  And all we really need is just a little
abstraction on that concept.

Eric
