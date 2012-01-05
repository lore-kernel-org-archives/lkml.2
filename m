Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab2AERMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:12:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36480 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab2AERMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:12:00 -0500
Date: Thu, 5 Jan 2012 09:11:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
Message-ID: <20120105171157.GA18486@google.com>
References: <m1ehvecf23.fsf@fess.ebiederm.org>
 <Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 05, 2012 at 11:47:54AM -0500, Alan Stern wrote:
> One problem (which was reported by a user last spring) is that
> del_gendisk() calls device_del() for the disk and bdi_unregister() for
> the disk's backing_dev_info structure.  Now, del_gendisk will leave the
> data structure in memory until the disk's refcount drops to 0, but
> bdi_unregister ignores refcounts and simply erases the bdi->dev
> pointer.  Once this happens, any attempt to call mark_buffer_dirty()
> (for example, by ext4_commit_super) will cause an oops.

Yeah, there were multiple bugs in block device hot-removal path.  I
got some of them fixed recently but didn't get to the bdi one yet.
It's a bug and needs to be fixed regardless of fs revoke support.

Thanks.

-- 
tejun
