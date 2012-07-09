Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2GIRLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:11:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58274 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2GIRLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:11:12 -0400
Date: Mon, 9 Jul 2012 10:11:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, shyju pv <shyju.pv@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>
Subject: Re: [PATCH] cgroup: cgroup_rm_files() was calling simple_unlink()
 with the wrong inode
Message-ID: <20120709171107.GC1341@google.com>
References: <20120628180712.GC22641@google.com>
 <4FED10DB.7040500@huawei.com>
 <20120629165809.GB21048@google.com>
 <4FEE98EE.1050409@huawei.com>
 <20120630064724.GC14083@ZenIV.linux.org.uk>
 <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com>
 <20120630083421.GD14083@ZenIV.linux.org.uk>
 <20120703171033.GC555@google.com>
 <20120703173806.GD555@google.com>
 <4FF3D757.9060905@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF3D757.9060905@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 01:40:39PM +0800, Li Zefan wrote:
> Tejun Heo wrote:
> 
> >>From 6da2689412c78b97716ec524cc30baf7b46508cd Mon Sep 17 00:00:00 2001
> > From: Tejun Heo <tj@kernel.org>
> > Date: Tue, 3 Jul 2012 10:32:26 -0700
> > 
> > While refactoring cgroup file removal path, 05ef1d7c4a "cgroup:
> > introduce struct cfent" incorrectly changed the @dir argument of
> > simple_unlink() to the inode of the file being deleted instead of that
> > of the containing directory.
> > 
> > The effect of this bug is minor - ctime and mtime of the parent
> > weren't properly updated on file deletion.
> > 
> > Fix it by using @cgrp->dentry->d_inode instead.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
> 
> 
> Acked-By: Li Zefan <lizefan@huawei.com>

I think it's now a bit too late for for-3.5-fixes and the effect of
the bug is rather minor.  Applied to cgroup/for-3.6 w/ stable cc'd.

Thanks.

-- 
tejun
