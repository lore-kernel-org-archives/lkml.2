Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0G0GpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 02:45:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55228 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab0G0GpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 02:45:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 27 Jul 2010 15:39:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: balbir@linux.vnet.ibm.com, Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
        linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
        Vivek Goyal <vgoyal@redhat.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
        taka@valinux.co.jp, Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-Id: <20100727153951.f7e98ec0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTi=HrZoBL8MKJDOX-==iC5OcBJ4EmSG41BvO4Yqe@mail.gmail.com>
References: <4C369009.80503@ds.jp.nec.com>
	<20100726064149.GP14369@balbir.in.ibm.com>
	<AANLkTi=HrZoBL8MKJDOX-==iC5OcBJ4EmSG41BvO4Yqe@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jul 2010 23:40:07 -0700
Greg Thelen <gthelen@google.com> wrote:

> On Sun, Jul 25, 2010 at 11:41 PM, Balbir Singh
> <balbir@linux.vnet.ibm.com> wrote:
> > * Munihiro Ikeda <m-ikeda@ds.jp.nec.com> [2010-07-08 22:57:13]:
> >
> >> These RFC patches are trial to add async (cached) write support on blkio
> >> controller.
> >>
> >> Only test which has been done is to compile, boot, and that write bandwidth
> >> seems prioritized when pages which were dirtied by two different processes in
> >> different cgroups are written back to a device simultaneously.  I know this
> >> is the minimum (or less) test but I posted this as RFC because I would like
> >> to hear your opinions about the design direction in the early stage.
> >>
> >> Patches are for 2.6.35-rc4.
> >>
> >> This patch series consists of two chunks.
> >>
> >> (1) iotrack (patch 01/11 -- 06/11)
> >>
> >> This is a functionality to track who dirtied a page, in exact which cgroup a
> >> process which dirtied a page belongs to.  Blkio controller will read the info
> >> later and prioritize when the page is actually written to a block device.
> >> This work is originated from Ryo Tsuruta and Hirokazu Takahashi and includes
> >> Andrea Righi's idea.  It was posted as a part of dm-ioband which was one of
> >> proposals for IO controller.
> >>
> >
> > Does this reuse the memcg infrastructure, if so could you please add a
> > summary of the changes here.
> >
> >>
> >> (2) blkio controller modification (07/11 -- 11/11)
> >>
> >> The main part of blkio controller async write support.
> >> Currently async queues are device-wide and async write IOs are always treated
> >> as root group.
> >> These patches make async queues per a cfq_group per a device to control them.
> >> Async write is handled by flush kernel thread.  Because queue pointers are
> >> stored in cfq_io_context, io_context of the thread has to have multiple
> >> cfq_io_contexts per a device.  So these patches make cfq_io_context per an
> >> io_context per a cfq_group, which means per an io_context per a cgroup per a
> >> device.
> >>
> >>
> >> This might be a piece of puzzle for complete async write support of blkio
> >> controller.  One of other pieces in my head is page dirtying ratio control.
> >> I believe Andrea Righi was working on it...how about the situation?
> >>
> >
> > Greg posted the last set of patches, we are yet to see another
> > iteration.
> 
> I am waiting to post the next iteration of memcg dirty limits and ratios until
> Kame-san posts light-weight lockless update_stat().  I can post the dirty ratio
> patches before the lockless updates are available, but I imagine there will be
> a significant merge.  So I prefer to wait, assuming that thee changes will be
> coming in the near future.
> 
will post RFC version today.

But maybe needs some sort-out..I'll CC you.

Thanks,
-Kame

