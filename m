Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2ACNjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 08:39:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab2ACNjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 08:39:44 -0500
Date: Tue, 3 Jan 2012 14:39:42 +0100
From: Jan Kara <jack@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-ID: <20120103133942.GC31457@quack.suse.cz>
References: <20120103124331.f0f0043f8ca464c9ff13f4d3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103124331.f0f0043f8ca464c9ff13f4d3@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Tue 03-01-12 12:43:31, Stephen Rothwell wrote:
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/super.c:230:13: error: static declaration of 'put_super' follows non-static declaration
> include/linux/fs.h:2493:13: note: previous declaration of 'put_super' was here
> 
> Caused by commit eab99e355c00 ("trim fs/internal.h") interacting with
> commit 4789fd4495a4 ("quota: Fix deadlock with suspend and quotas") from
> the ext3 tree.
> 
> I applied the following (probably not the best) merge fix patch for today:
  Thanks Stephen! Al, how shall we resolve this? You wrote you can provide
a VFS helper like get_super() which will also guarantee that the fs is
unfrozen.  That could be used in quotactl_block() and fsync_bdev(). If you
plan to do this for 3.3 then I can just remove the quota fix and let you
do it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
