Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab1GYWwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 18:52:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40405 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1GYWwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 18:52:06 -0400
Date: Mon, 25 Jul 2011 23:51:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
        Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [Patch] VFS : mount lock scalability for files systems without
 mount point   (WAS vfsmount lock issues on very large ppc64 box)
Message-ID: <20110725225154.GD22133@ZenIV.linux.org.uk>
References: <20110717010427.GC5359@parisc-linux.org>
 <20110717084630.GC8006@one.firstfloor.org>
 <1310977028.5756.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110718154008.GA29593@infradead.org>
 <20110718155141.GA11013@ZenIV.linux.org.uk>
 <1311093158.2707.75.camel@schen9-DESK>
 <20110721204042.GB31405@ZenIV.linux.org.uk>
 <1311294452.2576.18.camel@schen9-DESK>
 <20110723132411.GA22183@infradead.org>
 <1311633550.2576.33.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311633550.2576.33.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 03:39:10PM -0700, Tim Chen wrote:
> On Sat, 2011-07-23 at 09:24 -0400, Christoph Hellwig wrote:
> > I think you actually want this done in kern_mount_data, as both
> > ipc and proc want long-term references as well.  I also suspect with
> > additional creep of container awareness more internal mounts will switch
> > to kern_mount_data.  Al, what do you think about simply passing the
> > private data argument to kern_mount and kill kern_mount_data?  It's not
> > like the additional argument is going to cause us any pain.
> > 
> > 
> 
> I've updated the patch and merged mnt_make_longterm into
> kern_mount_data to address your comments.  I've left the kern_mount
> and kern_mount_data as separate functions for now.  Let me know
> if removing kern_mount_data is preferable instead.

It's mostly merged in mainline already...  BTW, you forgot to export
that sucker - mtdchar can be modular.
