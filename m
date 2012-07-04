Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558Ab2GDGUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:20:14 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:3314 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926Ab2GDGUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:20:09 -0400
Message-ID: <4FF3E063.5010604@huawei.com>
Date: Wed, 4 Jul 2012 14:19:15 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: shyju pv <shyju.pv@huawei.com>, Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <levinsasha928@gmail.com>
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
References: <4FEEA5CB.8070809@huawei.com> <20120703170317.GB555@google.com> <20120703225218.GF555@google.com>
In-Reply-To: <20120703225218.GF555@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.88.115]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/7/4 6:52, Tejun Heo wrote:

> Hello,
> 
> Shyju, can you please test the following patch?
> 
> Sasha, can you please re-test your test case with this patch?  I don't
> think fa980ca87d "cgroup: superblock can't be released with active
> dentries" did anything useful.  cgroup always calls d_iput() and
> d_release() in succession from the same context.  It may just have
> stretched the timing a bit to hide the race.
> 
> Li, this patch reverts fa980ca87d and wraps dput() in css_dput_fn()
> with s_active refs.  Positive dentry ref means that we have active ref
> on sb, so wrapping the final dput() with extra s_active ref should
> avoid premature super destruction. 


> I think we're horridly broken for

> root cgroup tho - and it has been broken for very long time.  I think
> it's mostly hidden because most (all?) controllers short-circuit root
> cgroup.  Eh, well....
> 

Could you elaborate a bit on what's broken for root cgroup?

