Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852Ab1LPVvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 16:51:55 -0500
Received: from numidia.opendz.org ([98.142.220.152]:51614 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760426Ab1LPVvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 16:51:48 -0500
Date: Fri, 16 Dec 2011 22:54:51 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [PATCH] mm: add missing mutex lock arround notify_change
Message-ID: <20111216215451.GA20271@dztty>
References: <20111216112534.GA13147@dztty>
 <20111216125556.db2bf308.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216125556.db2bf308.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 12:55:56PM -0800, Andrew Morton wrote:
> On Fri, 16 Dec 2011 12:25:34 +0100
> Djalal Harouni <tixxdz@opendz.org> wrote:
> 
> > 
> > Calls to notify_change() must hold i_mutex.
> > 
>
> ...
> 
> <does a quick audit>
> 
> fs/hpfs/namei.c and fs/nfsd/vfs.c:nfsd_setattr() aren't obviosuly
> holding that lock when calling notify_change().  Everything else under
> fs/ looks OK.

fs/nfsd/vfs.c:nfsd_setattr() is calling fh_lock() which calls
mutex_lock_nested() with the appropriate i_mutex of the dentry object.
There are some extra functions before the lock which are related to nfsd.

fs/hpfs/namei.c:hpfs_unlink() is using hpfs_lock() to lock the whole
filesystem.

So they are OK.

-- 
tixxdz
http://opendz.org
