Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab0KHWjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:39:04 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42240 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab0KHWjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:39:03 -0500
Date: Mon, 8 Nov 2010 23:38:38 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Thelen <gthelen@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Andrea Righi <arighi@develer.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] memcg: use native word to represent dirtyable pages
Message-ID: <20101108223838.GM23393@cmpxchg.org>
References: <1288973333-7891-1-git-send-email-minchan.kim@gmail.com>
 <20101106010357.GD23393@cmpxchg.org>
 <AANLkTin9m65JVKRuStZ1-qhU5_1AY-GcbBRC0TodsfYC@mail.gmail.com>
 <20101107215030.007259800@cmpxchg.org>
 <20101107220353.115646194@cmpxchg.org>
 <AANLkTi=qO84k-KWaG2R_nQr7vxRA2E7DbO4=XhVrFzjv@mail.gmail.com>
 <xr93aaljbghg.fsf@ninji.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xr93aaljbghg.fsf@ninji.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 02:25:15PM -0800, Greg Thelen wrote:
> Minchan Kim <minchan.kim@gmail.com> writes:
> 
> > On Mon, Nov 8, 2010 at 7:14 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> >> The memory cgroup dirty info calculation currently uses a signed
> >> 64-bit type to represent the amount of dirtyable memory in pages.
> >>
> >> This can instead be changed to an unsigned word, which will allow the
> >> formula to function correctly with up to 160G of LRU pages on a 32-bit
> Is is really 160G of LRU pages?  On 32-bit machine we use a 32 bit
> unsigned page number.  With a 4KiB page size, I think that maps 16TiB
> (1<<(32+12)) bytes.  Or is there some other limit?

Yes, the dirty limit we calculate from it :)

We have to be able to multiply this number by up to 100 (maximum dirty
ratio value) without overflowing.
