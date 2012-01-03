Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab2ACDaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 22:30:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38004 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2ACDaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 22:30:07 -0500
Date: Tue, 3 Jan 2012 03:30:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, dm-devel@redhat.com
Subject: Re: [PATCH] deadlock with suspend and quotas
Message-ID: <20120103033005.GZ23916@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 03:25:16PM -0500, Mikulas Patocka wrote:

> The following patch fixes the deadlock. When the quota subsystem takes s_umount,
> it checks if the filesystem is frozen. If it is, we drop s_umount, wait for
> the filesystem to resume and retry.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> CC: stable@kernel.org

So basically you want a variant of get_super() that would get you a
superblock for this bdev, locked and unfrozen?  Fair enough, but
	* that should be a proper helper in super.c, rather than
open-coded in fs/quota/quota.c, of all places
	* what about other existing callers get_super() and its friends?

and while we are at it, why in damnation name is it exported?  The only
caller outside of core VFS is under #if 0...
