Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab0GMElZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 00:41:25 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51249 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0GMElX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 00:41:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Jul 2010 13:36:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Nauman Rafique <nauman@google.com>, Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
        linux-kernel@vger.kernel.org, Ryo Tsuruta <ryov@valinux.co.jp>,
        taka@valinux.co.jp, Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-Id: <20100713133636.73367cae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100712131805.GA12918@redhat.com>
References: <4C369009.80503@ds.jp.nec.com>
	<20100709134546.GC3672@redhat.com>
	<4C37BC1A.20102@ds.jp.nec.com>
	<AANLkTikECHfrksrk3QnD3X07pmgXdpo5-fv7hDLm2Zxw@mail.gmail.com>
	<20100710132417.GA2752@redhat.com>
	<20100712092004.3b27e13e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100712131805.GA12918@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 09:18:05 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> > I've just waited for dirty-ratio patches because I know someone is working on.
> > But, hmm, I'll consider to start work by myself.
> > 
> 
> If you can spare time to get it going, it would be great.
> 
> > (Off-topic)
> > BTW, why io-cgroup's hierarchy level is limited to 2 ?
> > Because of that limitation, libvirt can't work well...
> 
> Because current CFQ code is not written to support hierarchy. So it was
> better to not allow creation of groups inside of groups to avoid suprises.
> 
> We need to figure out something for libvirt. One of the options would be
> that libvirt allows blkio group creation in /root. Or one shall have to
> look into hierarchical support in CFQ.
> 

Hmm, can't we start from a hierarchy which doesn't support inheritance ?
IOW, blkio cgroup has children directories but all cgroups are treated as
flat. In future, true hierarchy support may be added and you may able to
use it via mount option....
For example, memory cgroup's hierarchy support is optional..because it's slow.

Cgroup's feature as mounting several subsystems at a mount point at once
is very useful in many case.

Thanks
-Kame

