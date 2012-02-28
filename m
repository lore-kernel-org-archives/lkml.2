Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab2B1KQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:16:04 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49330 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2B1KQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:16:01 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, viro@zeniv.linux.org.uk, hughd@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hugetlbfs: Add new rw_semaphore to fix truncate/read race
In-Reply-To: <20120227151135.7d4076c6.akpm@linux-foundation.org>
References: <1330280398-27956-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120227151135.7d4076c6.akpm@linux-foundation.org>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 28 Feb 2012 15:45:25 +0530
Message-ID: <87ipirclhe.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12022810-8878-0000-0000-00000177897A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012 15:11:35 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 26 Feb 2012 23:49:58 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> > 
> > Drop using inode->i_mutex from read, since that can result in deadlock with
> > mmap. Ideally we can extend the patch to make sure we don't increase i_size
> > in mmap. But that will break userspace, because application will have to now
> > use truncate(2) to increase i_size in hugetlbfs.
> > 
> > AFAIU i_mutex was added in hugetlbfs_read as per
> > http://lkml.indiana.edu/hypermail/linux/kernel/0707.2/3066.html
> 
> This patch comes somewhat out of the blue and I'm unsure what's going on.
> 
> You say there's some (potential?) deadlock with mmap, but it is
> undescribed.  Have people observed this deadlock?  Has it caused
> lockdep warnings?  Please update the changelog to fully describe the
> bug.

Viro explained the deadlock in detail here:

http://mid.gmane.org/20120217002726.GL23916@ZenIV.linux.org.uk

I will also update the commit message with this information.

> 
> Also, the new truncate_sem is undoumented.  This leaves readers to work
> out for themselves what it might be for.  Please let's add code
> comments which completely describe the race, and how this lock prevents
> it.
> 
> We should also document our locking rules.  When should code take this
> lock?  What are its ranking rules with respect to i_mutex, i_mmap_mutex
> and possibly others?
> 

Will update the patch with these details

Thanks
-aneesh

