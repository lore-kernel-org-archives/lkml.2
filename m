Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2KJQxw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 11:53:52 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38831 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2KJQxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 11:53:48 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Better support for (desktop) file search / indexing applications
Date: Sat, 10 Nov 2012 17:53:45 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.0-tp520; KDE/4.8.4; x86_64; ; )
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>, Jan Kara <jack@suse.cz>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, Eric Paris <eparis@redhat.com>,
        Nepomuk Mailing List <nepomuk@kde.org>,
        Linux Filesystem Development Mailinglist 
	<linux-fsdevel@vger.kernel.org>
References: <201211011352.42476.Martin@lichtvoll.de> <6898338.Kmf2pUBmi1@deuteros> (sfid-20121101_153747_091025_5495B23C)
In-Reply-To: <6898338.Kmf2pUBmi1@deuteros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211101753.46211.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 1. November 2012 schrieb Tvrtko Ursulin:
> On Thursday 01 November 2012 13:52:42 Martin Steigerwald wrote:
> ...
> 
> > The following two main issues led to the discussion about adding
> > notification about user inotify watch limit or even having it raised
> > automatically via some policy kit mechanism:
> > 
> > 1) Watches are not working recursively. Thus one has to add a watch
> > to each sub directory.
> > 
> > 2) There are inotify file move events. But one has to watch source
> > and destination directory to get notified of a file move between
> > these. Thus one has to watch each directory again. File moves
> > outside the watched home directory will go unnotified unless every
> > other accessible directory is watched as well.
> > 
> > 
> > What would be nice to have for file indexers would be:
> > 
> > 1) Recursive notifications. I.e. one watch for /home/martin can
> > notify about everything what happens in sub directories of that
> > directory.
> > 
> > 2) File move events that work from the source directory. I.e. if
> > watching a directory like /home/martin recursively it would be nice
> > to be notified about:
> > 
> > a) A file is moved from one sub directory inside /home/martin to
> > another one inside it.
> > 
> > b) A file is moved outside /home/martin
> > 
> > While these enhancement would likely fix the issues desktop file
> > search applications have with the kernel notification APIs, there
> > might be other approaches I did not yet thought off... so feel free
> > to comment with your thoughts on it.
> 
> I will only comment on the real time indexing part since I had some
> part in the inception of fanotify and still remember a thing or two
> about it.
> 
> Perhaps you should look into how hard would it be to add directory or
> rename, and unlink events to fanotify. It may not be too hard.
> 
> In that case, even though it does not support recursive directory
> watches (I tried to implement this some time around 2009. but found it
> impossible to wedge into the fanotify locking model), it does support
> mount point watches. Which for the desktop use might be sufficient,
> assuming /home is typically a separate filesystem.
> 
> Downside with  this approach is that you have to filter out the events
> you do not care about like /home/some-other-user, or even more if
> /home is not a separate filesystem. Which with the current fanotify
> state can be done using paths, but that includes resolving a link in
> procfs which may be a too expensive thing to do.
> 
> Or perhaps it is acceptable, if you for example only cared about
> CLOSE_WRITE events (closure of file which were open for writing).
> 
> So I think for this part you have two options, have a go of extending
> directory watches to be recursive, or live with the mount watches
> giving you too much traffic.

Thanks for your suggestions.

Still fanotify needs root access and thus this would need a daemon running 
as root and some policy kit stuff to access it and in case of mount point 
watches robust and secure code so that each user may only see his/her own 
results.

Any other ideas from anyone?

Thanks.
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
