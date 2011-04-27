Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab1D0Pmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:42:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36194 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab1D0Pmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CuAJ/e2UgQlz2T0/B30Q985ilTEng6sl5F/yJtRkl+WmGUkqW5nNGis4mgoP4KuhAQ
         P9CbrCI2Uz0dd7OIfDF3nhmvomuWlelNnyVYu4epLTyVDF6IIeV5kswaUfs+G6yYsbKV
         W1iekRT0gfTlckU1wLIkNtVQ6kyDuOOYqiyfw=
Date: Wed, 27 Apr 2011 17:42:39 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] drop_pagecache syscall
Message-ID: <20110427154238.GC15335@linux.betterlinux.com>
References: <1303853727-21444-1-git-send-email-andrea@betterlinux.com>
 <20110427001453.GD12436@dastard>
 <20110427085910.GA1749@linux.betterlinux.com>
 <BANLkTimrpNOHVfnund7uc=thf-c3_HxyYQ@mail.gmail.com>
 <20110427094717.GB1749@linux.betterlinux.com>
 <BANLkTi=ZNq4Yp3U5jVspsJixu4ckbdVjtQ@mail.gmail.com>
 <20110427095709.GA1687@linux.develer.com>
 <BANLkTi=+E+WzUgqEQTnRPmL1g5yPsXu8Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=+E+WzUgqEQTnRPmL1g5yPsXu8Bw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 11:25:47AM -0400, Mike Frysinger wrote:
> On Wed, Apr 27, 2011 at 05:57, Andrea Righi wrote:
> > On Wed, Apr 27, 2011 at 05:50:04AM -0400, Mike Frysinger wrote:
> >> On Wed, Apr 27, 2011 at 05:47, Andrea Righi wrote:
> >> > On Wed, Apr 27, 2011 at 05:10:41AM -0400, Mike Frysinger wrote:
> >> >> On Wed, Apr 27, 2011 at 05:01, Andrea Righi wrote:
> >> >> > On Wed, Apr 27, 2011 at 10:14:53AM +1000, Dave Chinner wrote:
> >> >> >> On Tue, Apr 26, 2011 at 11:35:27PM +0200, Andrea Righi wrote:
> >> >> >> > This functionality can be used by all the applications that want to have a
> >> >> >> > better control over the page cache management (for example to immediately drop
> >> >> >> > pages that for sure will not be reused in the near future, without calling
> >> >> >> > posix_fadvise() for all the files they've touched), or to provide a more fine
> >> >> >> > grained debugging feature usable by the filesystem benchmarks.
> >> >> >> >
> >> >> >> > The system call does not require root privileges and it can be called by any
> >> >> >> > unprivileged application. For example, we can write a userspace tool to run
> >> >> >> > something like this:
> >> >> >> >
> >> >> >> >   $ drop-pagecache /path/file_or_dir
> >> >> >>
> >> >> >> That's a potential DOS vector, I think. Drop the pagecache in a hard
> >> >> >> loop on the root fs of a busy server and watch it crawl...
> >> >> >
> >> >> > Yes, probably we could allow only the CAP_SYS_ADMIN tasks to execute
> >> >> > this syscall.
> >> >>
> >> >> if /proc/sys/vm/drop_caches has any checks other than file permission
> >> >> checks (i.e. UID==0), it'd probably be better to copy those rather
> >> >> than picking something different.
> >> >
> >> > ok, what about checking current_euid() == 0?
> >>
> >> that's not what i meant.  if the drop_caches file already has certain
> >> cap checks/whatever in place, let's use those.  if it doesnt, then
> >> picking a cap level as you proposed makes sense.
> >
> > mmh, drop_caches has a file ownership (root:root) and a permission mask
> > (0644), how to apply the same checks to a system call? The most similar
> > thing seems to check the current euid. Am I missing something?
> 
> my (limited) understanding is that you should be using cap checks, not UID
> -mike

Agreed. This was my initial proposal. It's not very good, but I also
think it's the best option for this case.

Thanks,
-Andrea
