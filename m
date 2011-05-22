Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1EVHN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 03:13:26 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38078 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528Ab1EVHNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 03:13:21 -0400
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
In-Reply-To: <m1boyvpo9r.fsf@fess.ebiederm.org>
References: <m11uzrvd26.fsf@fess.ebiederm.org>
	 <BANLkTim4q5dK6nOb=pVKbk1c8b-Nh_hBfA@mail.gmail.com>
	 <m1boyvpo9r.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 11:13:13 +0400
Message-ID: <1306048393.4092.8.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-21 at 17:33 -0700, Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Sat, May 21, 2011 at 4:39 PM, Eric W. Biederman
> > <ebiederm@xmission.com> wrote:
> >>
> >> In a hopeless quest to avoid conflicts when merging a new system call
> >> and wiring it up I have pulled in bits of net-next and the parisc tree.
> >> You have already pulled the net-next bits.  The parisc bits in my tree
> >> are:
> >
> > Ok, this just means that I won't pull from you.
> 
> Sure.  I will try to be a little more patient and resend the pull
> request after James has sent the pull request for the parisc tree.
> At which point the only unique changes in my tree will be mine.

Right ... effectively you're running a postmerge tree, since you now
depend on bits I have in the parisc tree.

Traditionally, the arch trees tend to go a bit later because they wait
to see if there's any fallout from x86; but this time, I think it looks
OK, so I've sent the pull request:

http://marc.info/?l=linux-parisc&m=130604805417277

As soon as that's in, you should be good to go.

James


> > It's that simple. We don't do this. Ever.
> 
> Hah. I seem to remember bits of pulling from non-rebasing trees being ok
> in well defined contexts.  This seems like one.  Especially when you
> have checked with the maintainers.
> 
> Plus all of the parisc bits in addition to being in the linux-next
> are trivially correct.
> 
> > Why the hell did you even worry about wiring up parisc system calls?
> > That's not your job.
> 
> Because in general it is the job of he who changes something to fix up
> every possible place.
> 
> Now maybe I went a little too far in trying to resolve the conflicts,
> but I did check with the David Miller and James Bottomley and they knew
> what I was doing.
> 
> Quite honestly adding system calls is a mess that know one seems to
> know how to do right.  So I flipped a coin and took a stab at it.

Right, the solution is reasonable and means linux-next doesn't have to
carry a conflict resolution patch for this.  It also means we agree on
the syscall numbering ...

The only real mistake was not waiting for the merge sequence: the base
trees have to go first before you can push a postmerge tree.

James


