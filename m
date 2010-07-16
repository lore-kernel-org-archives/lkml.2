Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738Ab0GPOgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 10:36:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965699Ab0GPOgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 10:36:16 -0400
Date: Fri, 16 Jul 2010 10:35:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nauman Rafique <nauman@google.com>,
        Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, linux-kernel@vger.kernel.org,
        Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
        Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-ID: <20100716143536.GE15382@redhat.com>
References: <4C37BC1A.20102@ds.jp.nec.com>
 <AANLkTikECHfrksrk3QnD3X07pmgXdpo5-fv7hDLm2Zxw@mail.gmail.com>
 <20100710132417.GA2752@redhat.com>
 <20100712092004.3b27e13e.kamezawa.hiroyu@jp.fujitsu.com>
 <20100712131805.GA12918@redhat.com>
 <20100713133636.73367cae.kamezawa.hiroyu@jp.fujitsu.com>
 <20100714142919.GA31449@redhat.com>
 <20100715090048.0b0120a0.kamezawa.hiroyu@jp.fujitsu.com>
 <20100716134353.GA15382@redhat.com>
 <20100716141549.GI19587@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100716141549.GI19587@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 03:15:49PM +0100, Daniel P. Berrange wrote:

[..]
> > libvirt will require modification to support blkio controller. I also 
> > noticed that libvirt by default puts every virtual machine into its
> > own cgroup. I think it might not be a very good strategy for blkio
> > controller because putting every virtual machine in its own cgroup
> > will kill overall throughput if each virtual machine is not driving
> > enough IO.
> 
> A requirement todo everything in the top level and not use a hiearchy
> for blkio makes this a pretty unfriendly controller to use. It seriously
> limits flexibility of what libvirt and host administrators can do and
> means we can't effectively split poilicy between them. It also means
> that if the blkio contorller were ever mounted at same point as another
> controller, you'd loose the hierarchy support for that other controller
> IMHO use of the cgroups hiearchy is key to making cgroups managable for
> applications. We can't have many different applications on a system
> all having to create many directories at the top level.
> 

I understand that not having hierarchical support is a huge limitation
and in future I would like to be there. Just that at the moment provinding
that support is hard as I am struggling with more basic issues which are
more important.

Secondly, just because some controller allows creation of hierarchy does
not mean that hierarchy is being enforced. For example, memory controller.
IIUC, one needs to explicitly set "use_hierarchy" to enforce hierarchy
otherwise effectively it is flat. So if libvirt is creating groups and
putting machines in child groups thinking that we are not interfering
with admin's policy, is not entirely correct.

So how do we make progress here. I really want to see blkio controller
integrated with libvirt.

About the issue of hierarchy, I can probably travel down the path of allowing
creation of hierarchy but CFQ will treat it as flat. Though I don't like it
because it will force me to introduce variables like "use_hierarchy" once
real hierarchical support comes in but I guess I can live with that.
(Anyway memory controller is already doing it.).

There is another issue though and that is by default every virtual
machine going into a group of its own. As of today, it can have
severe performance penalties (depending on workload) if group is not
driving doing enough IO. (Especially with group_isolation=1).

I was thinking of a model where an admin moves out the bad virtual
machines in separate group and limit their IO.

Vivek
