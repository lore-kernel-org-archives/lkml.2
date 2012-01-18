Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab2ARH5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 02:57:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63638 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab2ARH5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 02:57:30 -0500
Message-ID: <4F167BFD.7010307@cn.fujitsu.com>
Date: Wed, 18 Jan 2012 15:59:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Sha <handai.szj@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/2] cgroup: revise how we re-populate root directory
References: <4F13DA90.2000603@cn.fujitsu.com> <CAFj3OHUQzShbmdCKYhWMum=hqM5XqK-_wcDyUajnZ1XWFGX1Xg@mail.gmail.com>
In-Reply-To: <CAFj3OHUQzShbmdCKYhWMum=hqM5XqK-_wcDyUajnZ1XWFGX1Xg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-18 15:56:13,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-18 15:56:18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> @@ -1284,6 +1296,7 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>>        struct cgroupfs_root *root = sb->s_fs_info;
>>        struct cgroup *cgrp = &root->top_cgroup;
>>        struct cgroup_sb_opts opts;
>> +       unsigned long added_bits, removed_bits;
>>
>>        mutex_lock(&cgrp->dentry->d_inode->i_mutex);
>>        mutex_lock(&cgroup_mutex);
>> @@ -1294,6 +1307,9 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>>        if (ret)
>>                goto out_unlock;
>>
>> +       added_bits = opts.subsys_bits & ~root->subsys_bits;
>> +       removed_bits = root->subsys_bits & ~opts.subsys_bits;
>> +
> 
> Should it be the following？：
>           added_bits = opts.subsys_bits & ~root->actual_subsys_bits;
>           removed_bits = root->actual_subsys_bits & ~opts.subsys_bits;
> 

subsys_bits and actual_subsys_bits differ during cgroup_mount() only,
and in other places they are replaceable with each other.

Thanks for looking into this.
