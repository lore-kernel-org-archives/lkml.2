Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2F3HEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 03:04:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44398 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2F3HEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 03:04:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120630064724.GC14083@ZenIV.linux.org.uk>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
	<20120627182903.GP15811@google.com>
	<4FEBF4B7.2070105@huawei.com>
	<20120628180712.GC22641@google.com>
	<4FED10DB.7040500@huawei.com>
	<20120629165809.GB21048@google.com>
	<4FEE98EE.1050409@huawei.com>
	<20120630064724.GC14083@ZenIV.linux.org.uk>
Date: Sat, 30 Jun 2012 00:04:36 -0700
X-Google-Sender-Auth: 5Ejy4Lb3H7TSSL3HLnYTDSQm4nM
Message-ID: <CAOS58YNnU3J+c2ZQcRCesSoxn0dSJjDLBsZ2qzZ09X6N-ky0fQ@mail.gmail.com>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
From: Tejun Heo <tj@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Li Zefan <lizefan@huawei.com>, shyju pv <shyju.pv@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Al.

On Fri, Jun 29, 2012 at 11:47 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Jun 30, 2012 at 02:13:02PM +0800, Li Zefan wrote:
>> So it's bad to have dentry refcnts dangling after umount.
>
> No shit.  Yes, it is bad.  What on the Earth is cgroup code doing with
> those?  And what could it possibly want to do with dentry reference
> after the filesystem has been shut down, assuming it could hold one
> in the first place?

cgroup interface code was copied from sysfs back when it was
piggybacking internal data structures to dentries, so, unfortunately,
sysfs is still using dentries to manage internal data structures and
propagates internal refs to dentry refs. There seem to be several
places where dentry ref is held w/o active super ref triggering BUG on
umount. Longer term, it should be updated to share sysfs code, I
guess.

Thanks.

-- 
tejun
