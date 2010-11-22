Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0KVQmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:42:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37711 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab0KVQmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:42:52 -0500
Date: Mon, 22 Nov 2010 17:42:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: castet.matthieu@free.fr, Lin Ming <ming.m.lin@intel.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX
 protection for kernel data)
Message-ID: <20101122164247.GC21836@basil.fritz.box>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
 <1290431008.2072.119.camel@laptop>
 <1290443379.4cea9a73cd9ce@imp.free.fr>
 <1290443758.2072.318.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290443758.2072.318.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That seems to be a S3 specific code path, that won't fix anything.
> Simply do:
> 
> echo 0 > /sys/devices/system/cpu/cpu1/online;
> echo 1 > /sys/devices/system/cpu/cpu1/online;
> 
> and your machine will explode..

The SMP startup trampoline is copied I believe
and only executed in real mode without page tables.

So it's perhaps not the trampoline, but the early startup 
code that ends up being broken.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
