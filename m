Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0KCC1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 22:27:47 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43614 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0KCC1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 22:27:45 -0400
Date: Wed, 3 Nov 2010 07:57:33 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Nauman Rafique <nauman@google.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: Re: [RFC] blk-cgroup: Allow creation of hierarchical cgroups
Message-ID: <20101103022733.GJ3769@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101102222030.GI7198@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101102222030.GI7198@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@redhat.com> [2010-11-02 18:20:30]:

> o Allow hierarchical cgroup creation for blkio controller
> 
> o Currently we disallow it as both the io controller policies (throttling
>   as well as proportion bandwidth) do not support hierarhical accounting
>   and control. But the flip side is that blkio controller can not be used with
>   libvirt as libvirt creates a cgroup hierarchy deeper than 1 level.
> 
>   <top-level-cgroup-dir>/<controller>/libvirt/qemu/<virtual-machine-groups>
> 
> o So this patch will allow creation of cgroup hierarhcy but at the backend
>   everything will be treated as flat. So if somebody created a an hierarchy
>   like as follows.
> 
> 			root	
> 			/  \
> 		     test1 test2
> 			|
> 		     test3
> 
>   CFQ and throttling will practically treat all groups at same level.
> 			
> 				pivot
> 			     /  |   \  \
> 			root  test1 test2  test3
> 
> o Once we have actual support for hierarchical accounting and control
>   then we can introduce another cgroup tunable file "blkio.use_hierarchy"
>   which will be 0 by default but if user wants to enforce hierarhical
>   control then it can be set to 1. This way there should not be any
>   ABI problems down the line.
> 
> o The only not so pretty part is introduction of extra file "use_hierarchy"
>   down the line. Kame-san had mentioned that hierarhical accounting is
>   expensive in memory controller hence they keep it off by default. I
>   suspect same will be the case for IO controller also as for each IO
>   completion we shall have to account IO through hierarchy up to the root.
>   if yes, then it probably is not a very bad idea to introduce this extra
>   file so that it will be used only when somebody needs it and some people
>   might enable hierarchy only in part of the hierarchy. 
> 
> o This is how basically memory controller also uses "use_hierarhcy" and
>   they also allowed creation of hierarchies when actual backend support
>   was not available.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Three Cheers,
	Balbir
