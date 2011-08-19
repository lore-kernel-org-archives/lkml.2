Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab1HSWUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 18:20:52 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11897 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208Ab1HSWUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 18:20:50 -0400
Date: Sat, 20 Aug 2011 00:21:22 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Anton Altaparmakov <anton@tuxera.com>
cc: linux-kernel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net
Subject: Re: [PATCH 0/3] make ntfs_free() NULL safe
In-Reply-To: <39DAF2CE-95BC-4E0C-B30E-4686DF0E8D31@tuxera.com>
Message-ID: <alpine.LNX.2.00.1108200007520.31857@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1108192321130.31857@swampdragon.chaosbits.net> <39DAF2CE-95BC-4E0C-B30E-4686DF0E8D31@tuxera.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1746745099-1313792482=:31857"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1746745099-1313792482=:31857
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Fri, 19 Aug 2011, Anton Altaparmakov wrote:

> Hi,
> 
> On 19 Aug 2011, at 22:30, Jesper Juhl wrote:
> > Here's a small series of patches that make it safe to call ntfs_free() 
> > with a NULL pointer and reaps some bennefits from that.
> > 
> > The first patch in the series simply makes ntfs_free() safe to call with a 
> > NULL pointer. This fits with many other kernel freeing functions, that are 
> > generally safe to call with NULL pointers.
> > 
> > The second patch adds some documentation to ntfs_free() similar to what's 
> > already provided for the allocation functions.  ntfs_free() is fairly 
> > simple so you could argue that such documentation is not really needed, 
> > but I say it's still nice to have if for no other reason than 
> > completeness.
> > 
> > The third patch removes a number of tests for NULL pointers before calls 
> > to ntfs_free() that patch 1 make redundant.
> 
> Patches look fine.  Feel free to add my
> 
> 	Acked-by: Anton Altaparmakov <anton@tuxera.com>
> 
Thank you.

> and to send them to Linus for inclusion…
> 
I think I'll wait a bit before doing that. Hopefully some maintainer will 
pick them up and push them. But if that doesn't happen I'll make sure to 
re-sumbit them myself and point them higher up the hierarchy (with your 
ACK attached) :-)


> > This whole things came about because Coverity Prevent spotted that in 
> > fs/ntfs/runlist.c on line 967 we call ntfs_runlists_merge() which frees 
> > its second argument and we then explicitly free that argument via 
> > ntfs_free() again on line 970. This patch series also makes that a non 
> > issue.
> 
> Ah but Coverity Prevent is incorrect in its spotting!
> 
> Have a look yourself!
> 
> ntfs_runlists_merge() _ONLY_ frees its second argument if it returns success.  If it returns error it does _NOT_ free its second argument!
> 
On second inspection I believe you are right.

> And line 970 is _ONLY_ executed if ntfs_runlists_merge() returned error, i.e. in the case that the second argument was _NOT_ freed.  If the argument was freed, ntfs_runlists_merge() would have returned success, and then line 970 would never have been reached…
> 
> So I am afraid this is a bug in Coverity Prevent rather than in NTFS.  (-:
> 
I'll make a note in prevent that this is a false positive.

I still believe the 3 patches make sense though, regardless of this.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-1746745099-1313792482=:31857--
