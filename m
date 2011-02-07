Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1BGKAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 05:00:44 -0500
Received: from andariel.informatik.uni-erlangen.de ([131.188.30.242]:52253
	"EHLO andariel.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839Ab1BGKAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 05:00:43 -0500
X-Greylist: delayed 540 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Feb 2011 05:00:43 EST
Date: Mon, 7 Feb 2011 10:51:42 +0100
From: Daniel Tiron <dtiron@debian.armed.us>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Does the scheduler know about the cache topology?
Message-ID: <20110207095141.GA26132@andariel.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

I did some performance tests on a Core 2 Quad machine [1] with QEMU.
A QEMU instance creates one main thread and one thread for each virtual
CPU. There were two vms with one CPU each, which make four threads.

I tried different combinations where I pinned one tgread to one physical
core with taskset and measured the network performance between the vms
with iperf [2]. The best result was achieved with each vm (main and CPU
thread) assigned to one cache group (core 0 & 1 and 2 & 3).

But it also turns out that letting the scheduler handle the assignment
works well, too: The results where no pinning was done were just
slightly below the best. So I was wondering, is the Linux scheduler
aware of the CPU's cache topology?

I'm curious to hear your opinion.

Thanks,
Daniel

[1] Core 0 and 1 share one L2 cache and so do 2 and 3
[2] The topic of my research is networking performance. My interest in
    cache awareness is only a side effect.

