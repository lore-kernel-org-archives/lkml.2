Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab1FJXK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 19:10:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40827 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab1FJXKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 19:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l1bUtCaNI0C6nTT8/VxDDIJLlfsQdqT34gnrkvvG88e3fqkAOWglZiXayexffUMEGQ
         Nc8s8N4gldLtD48duDalzL/wmuY28MKG6AZ/zFgD+fny/qBobTRKtnryHbIrA3thosJj
         s8onLlY1yChHG97eEWy4l1M8bW29QSBJpS9Zk=
Date: Sat, 11 Jun 2011 02:10:46 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Why is CONFIG_FHANDLE an option??
Message-ID: <20110610231046.GA6811@p183.telecom.by>
References: <alpine.LNX.2.00.1106110001180.21722@swampdragon.chaosbits.net>
 <20110610223955.GA11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610223955.GA11521@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 11:39:55PM +0100, Al Viro wrote:
> On Sat, Jun 11, 2011 at 12:14:02AM +0200, Jesper Juhl wrote:
> > I just configured a new kernel based on a recent git checkout and when I 
> > had copied in my old configuration and did a "make oldconfig"I was greeted 
> > with
> > 
> >     open by fhandle syscalls (FHANDLE) [N/y/?] (NEW)
> > 
> > Ok, so I read the help text description and learn that it's about two new 
> > syscalls - open_by_handle_at(2) and name_to_handle_at(2).
> > 
> > My first thought at this point was "why are new syscalls even an option"?
> > 
> > Syscalls are in my oppinion ABI - having optional syscalls is just about 
> > as bad as removing a syscall. It basically means that users cannot know if 
> > the syscall is there and will need to test (it's bad enough having to 
> > check the kernel version, having to check for specific syscalls as well 
> > is just, well, annoying at best). 
> > 
> > Why are we making these optional?
> 
> Why not?

To avoid situations like "I need to use a program but suddenly
it requires system call which I compiled out a month before and now
I need to reboot like an idiot".

splice(2) wasn't given config option despite several times bigger .o
file compared to fshandle+exportfs.

So let's say it was always somewhat arbitrary decision.
