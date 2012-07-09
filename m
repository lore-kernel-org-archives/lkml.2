Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab2GIR2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:28:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59074 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2GIR2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:28:35 -0400
Date: Mon, 9 Jul 2012 10:28:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 2/3] cgroup: revise how we re-populate root directory
Message-ID: <20120709172831.GF1341@google.com>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120702142926.405632285@napanee.usersys.redhat.com>
 <20120709171748.GD1341@google.com>
 <20120709172220.GE1341@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709172220.GE1341@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 10:22:20AM -0700, Tejun Heo wrote:
> > Changing subsys_bits via remount is being deprecated.  No need to
> > worry about this.
> 
> Also, why does this matter?  The xattrs are kept in cgrp anyway.  Why
> does keeping dentry/inode around make difference?

Ah, okay, the file xattrs are kept in cfe which goes away on file
deletion.  :)

While changing subsys via remount is going away, I think removing
files selectively is still nice to have (even for single hierarchy).
I wish it were implemented differently tho.  As cgroup_rm_file()
already has @cft argument, wouldn't it be better to e.g. add @subsys
arg to cgroup_clear_directory() and let that walk subsys->cftsets
instead?

Thanks.

-- 
tejun
