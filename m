Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0HWWin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:38:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:57063 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab0HWWil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:38:41 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Tue, 24 Aug 2010 00:38:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Matt Helsley <matthltc@us.ibm.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008201438.16637.agruen@suse.de> <1282581973.2681.22.camel@localhost.localdomain>
In-Reply-To: <1282581973.2681.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008240038.17648.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 August 2010 18:46:13 Eric Paris wrote:
> Spent a bit of the weekend trying to figure out what you were doing and
> couldn't reproduce it or find it in the code because I had already fixed
> it (albeit for slightly different reasons).  The patch in question was:
> 
> http://marc.info/?l=linux-kernel&m=128214903125780&w=2
> 
> the vfsmount_test_mask was always initialized but since no vfsmount
> marks were found it was never cleared.  This left the code thinking that
> the given (inode) mark was interested in the event.

That seems to explain it.  I can no longer reproduce the bug with your current 
for-linus tree (3ba67c8a) using my previous method.

Sorry this bug was difficult for you to track down; I was not even aware of 
this fix until today.

> I think you could reproduce it differently
> 
> inotifywait -m -e open /mnt/tmp
> inotifywait -m -e close /mnt/tmp
> 
> and you would get both event types for both watches.

No, the open listener gets:
	d/ OPEN,ISDIR

and the close listener gets:
	d/ CLOSE_NOWRITE,CLOSE,ISDIR

I tried to reproduce the previously failing case with inotifywait. I can see 
that inotifywait receives five inotify events at the syscall level, but it 
will not report events with mask == 0.

Thanks,
Andreas
