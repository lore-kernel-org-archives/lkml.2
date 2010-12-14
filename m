Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab0LNRq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:46:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757638Ab0LNRqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:46:55 -0500
Date: Tue, 14 Dec 2010 18:46:26 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lin Feng Shen <shenlinf@cn.ibm.com>,
        Yuri L Volobuev <volobuev@us.ibm.com>,
        Mel Gorman <mel@linux.vnet.ibm.com>, dingc@cn.ibm.com,
        lnxninja <lnxninja@us.ibm.com>
Subject: Re: Deadlocks with transparent huge pages and userspace fs daemons
Message-ID: <20101214174626.GN5638@random.random>
References: <1288817005.4235.11393.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288817005.4235.11393.camel@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave and everyone,

On Wed, Nov 03, 2010 at 01:43:25PM -0700, Dave Hansen wrote:
> Hey Miklos,
> 
> When testing with a transparent huge page kernel:
> 
> 	http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/andrea/aa.git;a=summary
> 
> some IBM testers ran into some deadlocks.  It appears that the
> khugepaged process is trying to migrate one of a filesystem daemon's
> pages while khugepaged holds the daemon's mmap_sem for write.

The allocation under mmap_sem write mode in khugepaged bug should be
fixed in current aa.git based on 37-rc5:

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=shortlog
http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=commit;h=83e4d55d0014b3eeb982005d73f55ffcf2813504

Let me know how it goes, it's not very well tested yet (which is why I
didn't make a new submit yet).

I stick to my idea this is bug in userland and may trigger if your
daemon does mmap/munmap and the vma allocation under mmap_sem waits
for the I/O, but I don't want to show it with THP enabled, and this is
more scalable so it's definitely good idea and no downside whatsoever.

Thanks for the report,
Andrea
