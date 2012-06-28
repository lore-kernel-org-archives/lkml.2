Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab2F1SHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 14:07:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41666 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2F1SHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 14:07:16 -0400
Date: Thu, 28 Jun 2012 11:07:12 -0700
From: "tj@kernel.org" <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: shyju pv <shyju.pv@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup
 cgroup]
Message-ID: <20120628180712.GC22641@google.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
 <20120627182903.GP15811@google.com>
 <4FEBF4B7.2070105@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEBF4B7.2070105@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Thu, Jun 28, 2012 at 02:07:51PM +0800, Li Zefan wrote:
> > Hmm... fa980ca87d "cgroup: superblock can't be released with active
> > dentries" is supposed to have fixed that.  Looking into it.
> > 
> 
> 
> I think I know what happened here:
> 
> umount
>   deativate_super(sb)
>                        dput(subdir)
>                          subdir->d_count--
>                          d_release(subdir)
>                            deactivate_super(sb)
>                              shrink_dcache_for_umount(sb)
>                                BUG(root->d_count)!!
>                          root->d_count--

Can you please elaborate a bit?  I'm not really following?  Where does
the last root->d_count-- come from?

> I use this script to reproduce the bug:
> 
> mount -t cgroup -o cpu xxx /mnt
> mkdir /mnt/sub
> sleep 100 < /mnt/sub &
> kill $!
> wait $!
> rmdir /mnt/sub
> umount /mnt

Unfortunately, this doesn't reproduce the bug here either. :(

Thanks.

-- 
tejun
