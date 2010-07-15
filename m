Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab0GOALp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:11:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35252 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab0GOALn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:11:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 15 Jul 2010 09:00:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Nauman Rafique <nauman@google.com>, Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
        linux-kernel@vger.kernel.org, Ryo Tsuruta <ryov@valinux.co.jp>,
        taka@valinux.co.jp, Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-Id: <20100715090048.0b0120a0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100714142919.GA31449@redhat.com>
References: <4C369009.80503@ds.jp.nec.com>
	<20100709134546.GC3672@redhat.com>
	<4C37BC1A.20102@ds.jp.nec.com>
	<AANLkTikECHfrksrk3QnD3X07pmgXdpo5-fv7hDLm2Zxw@mail.gmail.com>
	<20100710132417.GA2752@redhat.com>
	<20100712092004.3b27e13e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100712131805.GA12918@redhat.com>
	<20100713133636.73367cae.kamezawa.hiroyu@jp.fujitsu.com>
	<20100714142919.GA31449@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jul 2010 10:29:19 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > Cgroup's feature as mounting several subsystems at a mount point at once
> > is very useful in many case.
> 
> I agree that it is useful but if some controllers are not supporting
> hierarchy, it just adds to more confusion. And later when hierarchy
> support comes in, there will be additional issue of keeping this file
> "use_hierarchy" like memory controller.
> 
> So at this point of time , I am not too inclined towards allowing hierarchical
> cgroup creation but treating them as flat in CFQ. I think it adds to the
> confusion and user space should handle this situation.
> 

Hmm. 

Could you fix error code in create blkio cgroup ? It returns -EINVAL now.
IIUC, mkdir(2) doesn't return -EINVAL as error code (from man.)
Then, it's very confusing. I think -EPERM or -ENOMEM will be much better.

Anyway, I need to see source code of blk-cgroup.c to know why libvirt fails
to create cgroup. Where is the user-visible information (in RHEL or Fedora)
about "you can't use blkio-cgroup via libvirt or libcgroup" ?

Thanks,
-Kame

