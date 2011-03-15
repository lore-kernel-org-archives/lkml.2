Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab1COKMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 06:12:03 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:27007 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879Ab1COKL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 06:11:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkUEAF7Xfk15LK5JgWdsb2JhbACmDRUBARYmJcJqDYVVBJJW
Date: Tue, 15 Mar 2011 21:11:55 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sage Weil <sage@newdream.net>
Cc: Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>,
        Jonathan Nieder <jrnieder@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org,
        mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de,
        l@jasper.es
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Message-ID: <20110315101155.GO15097@dastard>
References: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
 <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
 <201103111255.44979.arnd@arndb.de>
 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
 <20110311235607.GB15853@elie>
 <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
 <20110312021001.GA16833@elie>
 <20110312173217.GA24981@kroah.com>
 <1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl>
 <Pine.LNX.4.64.1103132114380.5145@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1103132114380.5145@cobra.newdream.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 09:29:17PM -0700, Sage Weil wrote:
> On Mon, 14 Mar 2011, Indan Zupancic wrote:
> > Everyone seems to want to add this new syncfs, but it's not even defined 
> > what it does. "Same as sync, but only on one fs" is IMHO not good 
> > enough, because sync's behaviour is pretty badly documented, and that's 
> > a system call.
> 
> How about the man page below?  I tried to avoid the somewhat antiquated 
> implementation specific terminology in the sync(2) man page.
> 
> I think adding this functionality into sync_file_range(2) is forcing 
> unrelated functionality into an existing interface; sync_file_range 
> operates on _files_, not an entire file system.  With each API addition it 
> is more important to make the interface simple and intuitive than to 
> minimize the size of our patches.  IMO that's why a new syscall is 
> preferable to, say, an equivalent ioctl.
> 
> Thanks-
> sage
> 
> 
> .TH SYNCFS 2 2011-03-13 "Linux" "Linux Programmer's Manual"
> .SH NAME
> syncfs \- commit cached file system state to stable storage
> .SH SYNOPSIS
> .B #include <unistd.h>
> .sp
> .B void syncfs(int fd);
> .SH DESCRIPTION
> .BR syncfs ()
> flushes any cached data modifications to the file system containing the 
> file referenced by the file descriptor
> .I fd
> to stable storage (usually a disk).  This includes the results of any
> file modifications or other file system operations that have completed
> prior to the call to
> .BR syncfs(2).
> This is similar to 
> .BR sync(2),
> but will commit changes for only a single file system instead of all
> mounted file systems.
> .SH ERRORS
> This function is always successful.

Perhaps we should consider propagating errors out to the user
application rather than discarding them in kernel and pretending we
can't ever have a write error?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
