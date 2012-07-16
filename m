Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab2GPQpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:45:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42143 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab2GPQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:45:32 -0400
Date: Mon, 16 Jul 2012 09:45:27 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: shyju pv <shyju.pv@huawei.com>, Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        viro@zeniv.linux.org.uk, levinsasha928@gmail.com
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
Message-ID: <20120716164527.GB30872@google.com>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
 <20120703225218.GF555@google.com>
 <4FF3E063.5010604@huawei.com>
 <20120708063536.GB19021@dhcp-172-17-108-109.mtv.corp.google.com>
 <4FFB8F39.9030209@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFB8F39.9030209@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 10, 2012 at 10:11:05AM +0800, Li Zefan wrote:
> Right, but that should be safe. The css objects of the root cgroup are
> allocated at boot, and won't be destroyed at umount.
> 
> Furthermore when a cgroup hierarchy is going to be unmounted, those css's
> will be made to point to a cgroup named dummytop in rebind_subsystems(),
> and there's a syncronize_rcu() in the end of the function, so accessing
> css->cgroup is always safe.
> 
> In this case, dummytop->dentry is NULL, and that's safe too, because
> cgroup_path() is aware of this case.

I see.  Thanks for the explanation.

-- 
tejun
