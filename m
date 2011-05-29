Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab1E2Ity (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 04:49:54 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:45458 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750779Ab1E2Itw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 04:49:52 -0400
Date: Sun, 29 May 2011 09:49:40 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH] ns: Wire up the setns system call for 2.6.40-rc1 or
 whatever
Message-ID: <20110529084940.GA26714@linux-mips.org>
References: <m1lixr4kz8.fsf@fess.ebiederm.org>
 <BANLkTi=-DHpvAm_9J9y+rOxB25e=4kCjYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=-DHpvAm_9J9y+rOxB25e=4kCjYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 10:55:55AM -0700, Linus Torvalds wrote:

> On Fri, May 27, 2011 at 7:28 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> >
> > 32bit and 64bit on x86 are tested and working.  The rest I have looked
> > at closely and I can't find any problems.
> 
> So I really don't think this was even worth it. I applied the patch,
> but I think that you should just have done the architecture you
> tested, and left it to arch maintainers to add it as they will.
> 
> That's how we tend to do this, and it works. It also avoids surprises
> when people then invariably end up having clashes due to system calls
> being added. Even in just the 15 hours since you sent the email, I had
> merged more code from ARM, and the patch no longer applied to my tree.
> It's trivial to fix up, so that's not the problem, but the problem is
> with different people adding system calls resulting in re-numbering.

Which just happened on MIPS; I had a conflict between sendmmsg and sysns.

People other than the maintainer adding new syscalls routinely goes wrong
for this or other reasons.

> In other words, it's simply better to strive to have *one* entity in
> charge of picking the system call number, rather than do it like this.
> Ergo: leave it to architecture maintainers to minimize the issue of
> system call renumbering.

Amen.

  Ralf
