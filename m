Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab2DYJtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:49:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:11364 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab2DYJtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:49:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="133581085"
From: Andi Kleen <andi@firstfloor.org>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20120424 release(doc update)[1/3]code
References: <4F96A881.7050507@gmail.com>
Date: Wed, 25 Apr 2012 02:49:19 -0700
In-Reply-To: <4F96A881.7050507@gmail.com> (Hui Zhu's message of "Tue, 24 Apr
	2012 21:20:01 +0800")
Message-ID: <m2mx60m99c.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hui Zhu <teawater@gmail.com> writes:

Could you please split it down further. a 9kLOC patch is pretty daunting.

>From a quick glance over some focus on simplication would be good: no
own allocators (kernel has enough), no own types (that would remove
asm), remove optional facilities like the private ring buffer. Some
obsolete code like using semaphores vs mutexes. The variable list looks
overcomplicated, just use an array? Generally too many macros I would
say, try using inlines or removing them.  

Do you have any rarely used optional features that could be left out a
version 1? If yes do that.  I'm sure with some effort the 9kLOC could be
much less. A patch half the size would be much easier to merge.

There are some things that checkpatch will likely warn about.

It would be good if you could describe the use case a bit better:
this is for the kernel only or also user applications?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
