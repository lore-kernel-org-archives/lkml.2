Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab1D0JrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:47:24 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59413 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab1D0JrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=NkRSp0vJOOxicDztSYW6+lgoqKmSHm87AfsTi8H0XTFOukFWLwbeH1wxaWg1f+kZqO
         HeZMfgMH8pKA50lwK8q7UvIgcRdC5Cs7vZloZq9LFdZcEfEO287zJvlzRyhMF2YoxsxH
         4DcpStLGcP10Y/VMEdJPsfrsmsjyjiIQZSoiY=
Date: Wed, 27 Apr 2011 11:47:17 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] drop_pagecache syscall
Message-ID: <20110427094717.GB1749@linux.betterlinux.com>
References: <1303853727-21444-1-git-send-email-andrea@betterlinux.com>
 <20110427001453.GD12436@dastard>
 <20110427085910.GA1749@linux.betterlinux.com>
 <BANLkTimrpNOHVfnund7uc=thf-c3_HxyYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimrpNOHVfnund7uc=thf-c3_HxyYQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 05:10:41AM -0400, Mike Frysinger wrote:
> On Wed, Apr 27, 2011 at 05:01, Andrea Righi wrote:
> > On Wed, Apr 27, 2011 at 10:14:53AM +1000, Dave Chinner wrote:
> >> On Tue, Apr 26, 2011 at 11:35:27PM +0200, Andrea Righi wrote:
> >> > This functionality can be used by all the applications that want to have a
> >> > better control over the page cache management (for example to immediately drop
> >> > pages that for sure will not be reused in the near future, without calling
> >> > posix_fadvise() for all the files they've touched), or to provide a more fine
> >> > grained debugging feature usable by the filesystem benchmarks.
> >> >
> >> > The system call does not require root privileges and it can be called by any
> >> > unprivileged application. For example, we can write a userspace tool to run
> >> > something like this:
> >> >
> >> >   $ drop-pagecache /path/file_or_dir
> >>
> >> That's a potential DOS vector, I think. Drop the pagecache in a hard
> >> loop on the root fs of a busy server and watch it crawl...
> >
> > Yes, probably we could allow only the CAP_SYS_ADMIN tasks to execute
> > this syscall.
> 
> if /proc/sys/vm/drop_caches has any checks other than file permission
> checks (i.e. UID==0), it'd probably be better to copy those rather
> than picking something different.

ok, what about checking current_euid() == 0?

Thanks,
-Andrea
