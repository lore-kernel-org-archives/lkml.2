Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0HRP71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 11:59:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab0HRP70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 11:59:26 -0400
Subject: Re: [GIT PULL] notification tree: directory events
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
In-Reply-To: <201008181747.15461.agruen@suse.de>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
	 <1281208514.2609.25.camel@dhcp231-200.rdu.redhat.com>
	 <201008162232.36873.agruen@suse.de>  <201008181747.15461.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 11:59:06 -0400
Message-ID: <1282147146.21419.165.camel@acb20005.ipt.aol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 17:47 +0200, Andreas Gruenbacher wrote:
> Eric,
> 
> one more thing that doesn't make sense is events on directories: when watching 
> a directory, some actions like reading a directory or creat()ing a file in the 
> directory will generate events (even open_perm and access_perm), but other 
> actions like hard linking files into the directory or removing files will not 
> create any events.  This means that fanotify currently cannot be used for 
> watching for directory changes.
> 
> In my opinion, events on directories should either be made to actually work, 
> or else no directory events at all should be generated.
> 
> Also, I can think of users of fanotify which are not concerned with directory 
> events at all.  It would make sense to allow such users to subscribe only to 
> file events and not receive any directory events which they will end up 
> ignoring anyway.
> 
> Again it shows that this code just wasn't ready to be merged yet ...

I'm going to file your e-mail into my todo list and hopefully I get the
time to look at the ability to ignore directory events.  Nothing hard
about it.  It's as easy as defining a flag and adding a conditional in
the code but it's not high on my list.

Thus far your e-mails have pointed out one bug in the permissions
implementation I am currently working fixing and a bunch of complaining
about features you can imagine someone might someday want but which
noone has actually stood up and said 'I will use this' or 'this sucks
for my use case'.  I can find all sorts of things around the kernel
where I can imagine some mythical users might want to do something
different but it isn't a reason to prevent merger.  I'd love to have
more review, I'm certainly going to look at your wish list, but don't
expect response to future trolling messages.

-Eric

