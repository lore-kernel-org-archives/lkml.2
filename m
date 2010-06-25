Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab0FYDu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 23:50:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:35164 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab0FYDuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 23:50:24 -0400
Date: Fri, 25 Jun 2010 13:50:18 +1000
From: Nick Piggin <npiggin@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andrew Lutomirski <luto@mit.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       drepper@redhat.com, torvalds@linux-foundation.org
Subject: Re: [rfc] new stat*fs-like syscall?
Message-ID: <20100625035018.GP10441@laptop>
References: <20100624131455.GA10441@laptop>
 <4C2366F7.5010200@mit.edu>
 <E1ORnGc-0008CL-Uo@pomaz-ex.szeredi.hu>
 <AANLkTikKTtNlWEgAL1s2uxIFDPZWn2FDYDQg96mpDsv8@mail.gmail.com>
 <E1ORnj2-0008JJ-PN@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ORnj2-0008JJ-PN@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 04:48:20PM +0200, Miklos Szeredi wrote:
> On Thu, 24 Jun 2010, Andrew Lutomirski wrote:
> > Wasn't the point that /proc/self/mounts (and presumably
> > /proc/self/mountinfo) isn't scalable and we wanted a syscall to query
> > it efficiently (and racelessly)?
> 
> The question was how to support statvfs() efficiently, and the only
> thing missing there is f_flags which can easily be added to the
> existing statfs() syscall.
> 
> A separate mount_info() syscall might possibly be useful, but that's
> another story.

Native statvfs() support is my motivation, but I am thinking that if
we are going to introduce a new syscall (or version rev the statfs
syscall somehow), then we should think hard about what else we can do.

More superblock info should be possible, more detailed info like like
related mounts will be costlier, so that may be better off as a
different syscall.

