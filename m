Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1L0WaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 17:30:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57933 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1L0WaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 17:30:18 -0500
Date: Tue, 27 Dec 2011 14:30:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool
 and fix blkcg percpu alloc deadlock
Message-ID: <20111227223012.GJ17712@google.com>
References: <20111222232433.GQ17084@google.com>
 <20111222154138.d6c583e3.akpm@linux-foundation.org>
 <20111223012112.GB12738@redhat.com>
 <20111222173820.3461be5d.akpm@linux-foundation.org>
 <20111223025411.GD12738@redhat.com>
 <20111222191144.78aec23a.akpm@linux-foundation.org>
 <20111223145856.GB16818@redhat.com>
 <20111227132501.ad7f895f.akpm@linux-foundation.org>
 <20111227220753.GH17712@google.com>
 <20111227142156.7943446e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111227142156.7943446e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Tue, Dec 27, 2011 at 02:21:56PM -0800, Andrew Morton wrote:
> <autorepeat>For those users who don't want the stats, stats shouldn't
> consume any resources at all.

Hmmm.... For common use cases - a few cgroups doing IOs to most likely
single physical device and maybe a couple virtual ones, I don't think
this would show up anywhere both in terms of memory and process
overhead.  While avoding it would be nice, I don't think that should
be the focus of optimization or design decisions.

> And I bet that the majority of the minority who want stats simply want
> to know "how much IO is this cgroup doing", and don't need per-cgroup,
> per-device accounting.
> 
> And it could be that the minority of the minority who want per-device,
> per-cgroup stats only want those for a minority of the time.
> 
> IOW, what happens if we give 'em atomic_add() and be done with it?

I really don't know.  That surely is an enticing idea tho.  Jens,
Vivek, can you guys chime in?  Is gutting out (or drastically
simplifying) cgroup-dev stats an option?  Are there users who are
actually interested in this stuff?

Thanks.

-- 
tejun
