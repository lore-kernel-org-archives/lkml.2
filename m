Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2KMP2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:28:53 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57952 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab2KMP2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:28:51 -0500
Date: Tue, 13 Nov 2012 19:28:46 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into
 inotify_inode_mark
Message-ID: <20121113152846.GJ7808@moon>
References: <20121112101440.665694060@openvz.org>
 <2910785.4Vm74eFJyi@deuteros>
 <20121113144036.GI7808@moon>
 <2176466.A8PC9hQJK4@deuteros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2176466.A8PC9hQJK4@deuteros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 03:02:22PM +0000, Tvrtko Ursulin wrote:
> On Tuesday 13 November 2012 18:40:36 Cyrill Gorcunov wrote:
> > On Tue, Nov 13, 2012 at 12:37:23PM +0000, Tvrtko Ursulin wrote:
> > >> Which would give about 26K of additional memory if c/r get used here.
> > >> 
> > >>  Not a big number i guess?
> > > 
> > > I am pretty sure there are desktop file indexing packages which use
> > > inotify or fanotify which will put a mark on every single directory within
> > > users home.
> > > 
> > > You probably need to test this with default installs of popular desktop
> > > environments and realistic home directories.
> > 
> > I'm about to shrink the handle down to 40/64 bytes as being proposed in one
> > of early review cycles (i'll do that with patch on top), which should
> > minimize the amount of memory needed (look, it's pretty clear that if the
> > system uses millions of inotify watchers each inotify mark will need the
> > fhandle here in c/r sake, i simply see no way at moment how to escape this
> 
> Well I spotted uncertainty in this thread about how many of these structures 
> will typically be instantiated at runtime which is what I tried to add to this 
> discussion. I have 60k directories in my home for example...

And I appreciate it, really, thanks for info!

> If you don't want to use information I provided that is your choice. Because 
> you are still probably doubling this structure. Give or take - I haven't 
> actually bothered counting.
> 
> Perhaps there could be a different way, where you could use additional space 
> only when it is actually used at runtime. But as I said, I am not following 
> closely.

Unfortunatelly at moment I see no way how to make it in on-demand fashion.

> 
> > completely, but if the c/r is turned off, which is by default, no
> > additional memory needed).
> 
> By turned on and off you are not talking about runtime but about kernel 
> compile time, right? Do you envisage distributions turning this on, like they 
> do for most things?

yeah, compile time only. i don't expect it to be turned on by default
sometime soon but sure distro people have own opinions.

	Cyrill
