Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab1FJWkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:40:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54350 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167Ab1FJWkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:40:02 -0400
Date: Fri, 10 Jun 2011 23:39:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Why is CONFIG_FHANDLE an option??
Message-ID: <20110610223955.GA11521@ZenIV.linux.org.uk>
References: <alpine.LNX.2.00.1106110001180.21722@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106110001180.21722@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 11, 2011 at 12:14:02AM +0200, Jesper Juhl wrote:
> Hello
> 
> I just configured a new kernel based on a recent git checkout and when I 
> had copied in my old configuration and did a "make oldconfig"I was greeted 
> with
> 
>     open by fhandle syscalls (FHANDLE) [N/y/?] (NEW)
> 
> Ok, so I read the help text description and learn that it's about two new 
> syscalls - open_by_handle_at(2) and name_to_handle_at(2).
> 
> My first thought at this point was "why are new syscalls even an option"?
> 
> Syscalls are in my oppinion ABI - having optional syscalls is just about 
> as bad as removing a syscall. It basically means that users cannot know if 
> the syscall is there and will need to test (it's bad enough having to 
> check the kernel version, having to check for specific syscalls as well 
> is just, well, annoying at best). 
> 
> Why are we making these optional?

Why not?  Software needs to test *anyway*, since it might run on earlier
kernels.  And "does that syscall return -ENOSYS" is self-documenting,
while "is the version higher than $MAGIC_NUMBER" is *not*.  Especially since
there's such thing as backports.

If you need to check that syscall is there, _check_ _it_.  Don't breed
dependencies on version numbers.
