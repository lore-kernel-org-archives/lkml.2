Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab2F3Grf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 02:47:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55145 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2F3Grd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 02:47:33 -0400
Date: Sat, 30 Jun 2012 07:47:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Li Zefan <lizefan@huawei.com>
Cc: "tj@kernel.org" <tj@kernel.org>, shyju pv <shyju.pv@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
Message-ID: <20120630064724.GC14083@ZenIV.linux.org.uk>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
 <20120627182903.GP15811@google.com>
 <4FEBF4B7.2070105@huawei.com>
 <20120628180712.GC22641@google.com>
 <4FED10DB.7040500@huawei.com>
 <20120629165809.GB21048@google.com>
 <4FEE98EE.1050409@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEE98EE.1050409@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2012 at 02:13:02PM +0800, Li Zefan wrote:

> dput will drop both the subdir and the root's dentry refcnt, but kill_sb will be called
> inbetween.

????!!!!??!?!?

> So it's bad to have dentry refcnts dangling after umount.

No shit.  Yes, it is bad.  What on the Earth is cgroup code doing with
those?  And what could it possibly want to do with dentry reference
after the filesystem has been shut down, assuming it could hold one
in the first place?
