Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab0CQAcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 20:32:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:35777 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab0CQAcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 20:32:08 -0400
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: munroesj@us.ibm.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
       drepper@redhat.com, ralf@linux-mips.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@teksavvy.com,
       torvalds@linux-foundation.org
In-Reply-To: <1268776570.19726.98.camel@spokane1.rchland.ibm.com>
References: <20100315134449.GB1653@linux-mips.org>
	 <4B9E4EB1.9010800@zytor.com>	<4B9E59B7.6060405@redhat.com>
	 <20100315.120004.209998642.davem@davemloft.net>
	 <4B9E8D67.8040209@zytor.com>  <1268685311.2335.38.camel@pasglop>
	 <1268776570.19726.98.camel@spokane1.rchland.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 11:31:14 +1100
Message-ID: <1268785874.2335.137.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 16:56 -0500, Steven Munroe wrote:
> On Tue, 2010-03-16 at 07:35 +1100, Benjamin Herrenschmidt wrote:
> > On Mon, 2010-03-15 at 12:41 -0700, H. Peter Anvin wrote:
> > > I don't see why syscall() can't change the type for its first argument
> > > -- it seems to be exactly what symbol versioning is for.
> > > 
> > > Doesn't change the fact that it is fundamentally broken, of course. 
> > 
> > No need to change the type of the first arg and go for symbol
> > versionning if you do something like I proposed earlier, there will be
> > no conflict between syscall() and __syscall() and both variants can
> > exist.
> > 
> One concern is the new syscall and the kernel have to match and mixing
> will not work. your proposal seems to impact all syscalls not just the
> one called via syscall API. These syscalls get generated inline which
> makes static linking very dangerous ...
> 
> So I think you do need both symbol versioning and kernel feature stubs
> (like xstat). That gets to be a lot of work

What do you mean ? My proposal is purely a change to the syscall()
function, nothing else. No kernel change, no ABI change, no change to
the way glibc normally calls syscalls internally, etc... just the
exported syscall() function to shift its arguments in order to avoid
losing register pair alignment.

And the change would still be compatible with existing userland code who
manually splits the 64-bit arguments to avoid the problem on power.

IE. Unless I've missed something, this would be a 100% backward
compatible change that simply make a whole class of syscall() use work
that didn't before on power (but did on x86), such as the one I hit in
hdparm for example.

Cheers,
Ben.


