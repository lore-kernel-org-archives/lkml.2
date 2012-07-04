Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab2GDFoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:44:25 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:20973 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880Ab2GDFoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:44:21 -0400
Message-ID: <4FF3D757.9060905@huawei.com>
Date: Wed, 4 Jul 2012 13:40:39 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, shyju pv <shyju.pv@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>
Subject: Re: [PATCH] cgroup: cgroup_rm_files() was calling simple_unlink()
 with the wrong inode
References: <20120627182903.GP15811@google.com> <4FEBF4B7.2070105@huawei.com> <20120628180712.GC22641@google.com> <4FED10DB.7040500@huawei.com> <20120629165809.GB21048@google.com> <4FEE98EE.1050409@huawei.com> <20120630064724.GC14083@ZenIV.linux.org.uk> <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com> <20120630083421.GD14083@ZenIV.linux.org.uk> <20120703171033.GC555@google.com> <20120703173806.GD555@google.com>
In-Reply-To: <20120703173806.GD555@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.88.115]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:

>>From 6da2689412c78b97716ec524cc30baf7b46508cd Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Tue, 3 Jul 2012 10:32:26 -0700
> 
> While refactoring cgroup file removal path, 05ef1d7c4a "cgroup:
> introduce struct cfent" incorrectly changed the @dir argument of
> simple_unlink() to the inode of the file being deleted instead of that
> of the containing directory.
> 
> The effect of this bug is minor - ctime and mtime of the parent
> weren't properly updated on file deletion.
> 
> Fix it by using @cgrp->dentry->d_inode instead.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>


Acked-By: Li Zefan <lizefan@huawei.com>
