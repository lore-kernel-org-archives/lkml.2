Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab0GNO3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:29:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab0GNO3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:29:36 -0400
Date: Wed, 14 Jul 2010 10:29:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nauman Rafique <nauman@google.com>, Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
        linux-kernel@vger.kernel.org, Ryo Tsuruta <ryov@valinux.co.jp>,
        taka@valinux.co.jp, Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-ID: <20100714142919.GA31449@redhat.com>
References: <4C369009.80503@ds.jp.nec.com>
 <20100709134546.GC3672@redhat.com>
 <4C37BC1A.20102@ds.jp.nec.com>
 <AANLkTikECHfrksrk3QnD3X07pmgXdpo5-fv7hDLm2Zxw@mail.gmail.com>
 <20100710132417.GA2752@redhat.com>
 <20100712092004.3b27e13e.kamezawa.hiroyu@jp.fujitsu.com>
 <20100712131805.GA12918@redhat.com>
 <20100713133636.73367cae.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713133636.73367cae.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 01:36:36PM +0900, KAMEZAWA Hiroyuki wrote:
> On Mon, 12 Jul 2010 09:18:05 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > > I've just waited for dirty-ratio patches because I know someone is working on.
> > > But, hmm, I'll consider to start work by myself.
> > > 
> > 
> > If you can spare time to get it going, it would be great.
> > 
> > > (Off-topic)
> > > BTW, why io-cgroup's hierarchy level is limited to 2 ?
> > > Because of that limitation, libvirt can't work well...
> > 
> > Because current CFQ code is not written to support hierarchy. So it was
> > better to not allow creation of groups inside of groups to avoid suprises.
> > 
> > We need to figure out something for libvirt. One of the options would be
> > that libvirt allows blkio group creation in /root. Or one shall have to
> > look into hierarchical support in CFQ.
> > 
> 
> Hmm, can't we start from a hierarchy which doesn't support inheritance ?
> IOW, blkio cgroup has children directories but all cgroups are treated as
> flat. In future, true hierarchy support may be added and you may able to
> use it via mount option....
> For example, memory cgroup's hierarchy support is optional..because it's slow.

I think doing that is even more cofusing to the user where cgroup dir
structure show hierarchy of groups but in practice that's not the case. It
is easier to deny creating child groups with-in groups right away and
let user space mount blkio at a different mount point and plan the
resource usage accordingly.

> 
> Cgroup's feature as mounting several subsystems at a mount point at once
> is very useful in many case.

I agree that it is useful but if some controllers are not supporting
hierarchy, it just adds to more confusion. And later when hierarchy
support comes in, there will be additional issue of keeping this file
"use_hierarchy" like memory controller.

So at this point of time , I am not too inclined towards allowing hierarchical
cgroup creation but treating them as flat in CFQ. I think it adds to the
confusion and user space should handle this situation.

Thanks
Vivek
