Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab1CVSj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:39:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48009 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab1CVSjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:39:23 -0400
Date: Tue, 22 Mar 2011 18:39:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
Subject: Re: [PATCH 0/6 v7] overlay filesystem - request for inclusion
Message-ID: <20110322183919.GV22723@ZenIV.linux.org.uk>
References: <20110322152602.053930811@szeredi.hu>
 <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinxD2rZnso3zfX0=-HQ9m7=zAjEtUepFO=uMe2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:36:09AM -0700, Linus Torvalds wrote:
> On Tue, Mar 22, 2011 at 8:26 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > Here's an updated version of the overlay filesystem. ?I'd like to
> > propose it for inclusion into mainline.
> 
> So on the whole it looked pretty small and simple. And most of the VFS
> level changes looked fine and I just reacted to the odd calling
> convention for open (I really think you should aim for ->open to have
> the basically same arguments as you made __dentry_open have: 'struct
> path', 'struct filp' and 'struct cred').
> 
> But I'd want Al's ack on the series. And also hear who uses it and how
> it's been tested?

To be honest, I *really* don't like to touch that before ->atomic_open()
is finished.  We are nearly there (the only remaining prereq is to sort out
revalidate vs. mountpoint crossing issues), so with any luck the neighborhood
of open() will be finished in for-next circa -rc3 or so.

As for the rest of it... I'll need to review that in details, but the first
impression from that code is that I don't like the way copyup is done.
Locking analysis would be really nice; AFAICS, it violates locking order
when called from e.g. ->setattr() and its protection against renames is
nowhere near enough.  I might be missing something subtle, but...
