Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914Ab2C2VMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933880Ab2C2VMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:12:49 -0400
Date: Thu, 29 Mar 2012 17:12:44 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockups shortly after booting in current git.
Message-ID: <20120329211244.GA18684@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ted Ts'o <tytso@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20120329155542.GA31285@redhat.com>
 <CA+55aFxOcMt_mcr+ZYwc-SpKbROnh4Gn7jqrFY_SZcBy1Ev7Qw@mail.gmail.com>
 <20120329182632.GA6891@redhat.com>
 <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
 <20120329195354.GA11790@redhat.com>
 <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
 <20120329202619.GA14001@redhat.com>
 <20120329203926.GA13970@thunk.org>
 <CA+55aFwJkN2BmZJmWfB6FU0TuVKfmh4um8pMKYVUk3aG7JkNwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwJkN2BmZJmWfB6FU0TuVKfmh4um8pMKYVUk3aG7JkNwQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 01:59:33PM -0700, Linus Torvalds wrote:
 > On Thu, Mar 29, 2012 at 1:39 PM, Ted Ts'o <tytso@mit.edu> wrote:
 > >
 > > I'd suggest restricting the bisect to fs/ first, and if that comes up
 > > with something non-sensical, you can always use the good/bad data
 > > points for a whole tree bisect.
 > >
 > > One commit that you might want to try testing is b43d17f31^, and see
 > > whether that works.  One potential commit that might be suspicious is
 > > b43d17f31 given the stack trace shows one process apparently waiting
 > > on PageWriteback.
 > 
 > Ahh, that does sound interesting and relevant.
 > 
 > Yeah, maybe the directed approach is worth it. In fact, considering
 > the above commie, maybe it might be worth it to be *very* directed,
 > and just test that one thing first, and maybe even skip the bisection
 > entirely and just test a revert if it looks promising.

I'll try a build with just that reverted, given the bisect build is taking a while.

Any thoughts on any printk's I could add to verify a situation occurred or not ?
The problem with bisecting a bug like this is that it's hard to tell if
the bug has been fixed, or if I've just not hit it yet.

	Dave

