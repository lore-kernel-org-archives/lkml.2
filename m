Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab1L0WV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 17:21:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1L0WV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 17:21:57 -0500
Date: Tue, 27 Dec 2011 14:21:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111227142156.7943446e.akpm@linux-foundation.org>
In-Reply-To: <20111227220753.GH17712@google.com>
References: <20111222230047.GN17084@google.com>
	<20111222151649.de57746f.akpm@linux-foundation.org>
	<20111222232433.GQ17084@google.com>
	<20111222154138.d6c583e3.akpm@linux-foundation.org>
	<20111223012112.GB12738@redhat.com>
	<20111222173820.3461be5d.akpm@linux-foundation.org>
	<20111223025411.GD12738@redhat.com>
	<20111222191144.78aec23a.akpm@linux-foundation.org>
	<20111223145856.GB16818@redhat.com>
	<20111227132501.ad7f895f.akpm@linux-foundation.org>
	<20111227220753.GH17712@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011 14:07:53 -0800
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Tue, Dec 27, 2011 at 01:25:01PM -0800, Andrew Morton wrote:
> > umm, we've already declared that it is OK to completely waste this
> > memory for the users (probably a majority) who will not be using
> > these stats.
> 
> We're talking about combinatorial combinations where only small subset
> is usually expected to be used and, in addition to the absolute usage,
> there's big advantage in showing behavior which users would expect.
> If 1000 cgroups are doing IOs to 1000 devices, it's expected to
> consume some amount of resource.

<autorepeat>For those users who don't want the stats, stats shouldn't
consume any resources at all.

And I bet that the majority of the minority who want stats simply want
to know "how much IO is this cgroup doing", and don't need per-cgroup,
per-device accounting.

And it could be that the minority of the minority who want per-device,
per-cgroup stats only want those for a minority of the time.

IOW, what happens if we give 'em atomic_add() and be done with it?

