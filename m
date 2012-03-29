Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab2C2Ujg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:39:36 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:43532 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933106Ab2C2Ujb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:39:31 -0400
Date: Thu, 29 Mar 2012 13:39:26 -0700
From: "Ted Ts'o" <tytso@mit.edu>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockups shortly after booting in current git.
Message-ID: <20120329203926.GA13970@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20120329155542.GA31285@redhat.com>
 <CA+55aFxOcMt_mcr+ZYwc-SpKbROnh4Gn7jqrFY_SZcBy1Ev7Qw@mail.gmail.com>
 <20120329182632.GA6891@redhat.com>
 <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
 <20120329195354.GA11790@redhat.com>
 <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
 <20120329202619.GA14001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329202619.GA14001@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 04:26:19PM -0400, Dave Jones wrote:
> 
> I'll go back to trying the bisect now that I know how to reproduce it quickly.
> Do you think it might be worth restricting the bisect to fs/ ?
> Or shall I just do the whole tree bisect from 3.3 ?

I'd suggest restricting the bisect to fs/ first, and if that comes up
with something non-sensical, you can always use the good/bad data
points for a whole tree bisect.

One commit that you might want to try testing is b43d17f31^, and see
whether that works.  One potential commit that might be suspicious is
b43d17f31 given the stack trace shows one process apparently waiting
on PageWriteback.

					- Ted
