Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0HBU7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:59:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab0HBU7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:59:23 -0400
Date: Mon, 2 Aug 2010 16:58:34 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
        Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, Andrea Righi <righi.andrea@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
        balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-ID: <20100802205834.GD24697@redhat.com>
References: <4C369009.80503@ds.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 10:57:13PM -0400, Munehiro Ikeda wrote:
> These RFC patches are trial to add async (cached) write support on blkio
> controller.
> 
> Only test which has been done is to compile, boot, and that write bandwidth
> seems prioritized when pages which were dirtied by two different processes in
> different cgroups are written back to a device simultaneously.  I know this
> is the minimum (or less) test but I posted this as RFC because I would like
> to hear your opinions about the design direction in the early stage.
> 
> Patches are for 2.6.35-rc4.
> 
> This patch series consists of two chunks.
> 
> (1) iotrack (patch 01/11 -- 06/11)
> 
> This is a functionality to track who dirtied a page, in exact which cgroup a
> process which dirtied a page belongs to.  Blkio controller will read the info
> later and prioritize when the page is actually written to a block device.
> This work is originated from Ryo Tsuruta and Hirokazu Takahashi and includes
> Andrea Righi's idea.  It was posted as a part of dm-ioband which was one of
> proposals for IO controller.
> 
> 
> (2) blkio controller modification (07/11 -- 11/11)
> 
> The main part of blkio controller async write support.
> Currently async queues are device-wide and async write IOs are always treated
> as root group.
> These patches make async queues per a cfq_group per a device to control them.
> Async write is handled by flush kernel thread.  Because queue pointers are
> stored in cfq_io_context, io_context of the thread has to have multiple
> cfq_io_contexts per a device.  So these patches make cfq_io_context per an
> io_context per a cfq_group, which means per an io_context per a cgroup per a
> device.
> 
> 

Muuh,

You will require one more piece and that is support for per cgroup request
descriptors on request queue. With writes, it is so easy to consume those
128 request descriptors.

Thanks
Vivek
