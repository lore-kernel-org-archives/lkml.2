Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab0LWFfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 00:35:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098Ab0LWFfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 00:35:12 -0500
Date: Wed, 22 Dec 2010 21:28:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohui Zheng <shaohui.zheng@linux.intel.com>
Cc: shaohui.zheng@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, lethal@linux-sh.org, ak@linux.intel.com,
        rientjes@google.com, dave@linux.vnet.ibm.com, gregkh@suse.de,
        Ingo Molnar <mingo@elte.hu>, Len Brown <len.brown@intel.com>,
        Yinghai Lu <Yinghai.Lu@Sun.COM>, Tejun Heo <tj@kernel.org>,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [5/7, v9] NUMA Hotplug Emulator: Support cpu probe/release in
 x86_64
Message-Id: <20101222212804.a164f488.akpm@linux-foundation.org>
In-Reply-To: <20101223022428.GB12333@shaohui>
References: <20101210073119.156388875@intel.com>
	<20101210073242.670777298@intel.com>
	<20101222162727.56b830b0.akpm@linux-foundation.org>
	<20101223013410.GA11356@shaohui>
	<20101222192118.2d286ca9.akpm@linux-foundation.org>
	<20101223022428.GB12333@shaohui>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Dec 2010 10:24:28 +0800 Shaohui Zheng <shaohui.zheng@linux.intel.com> wrote:

> > 
> > Why *does* it check `count' and then not use it?
> > 
> 
> it is a tricky thing. When I debug it under a Virtual Machine, If I do a cpu
> probe via sysfs cpu/probe interface, The function arch_cpu_probe will be called
> __three__ times, but only one call is valid, so I add a check on `count` to
> ignore the invalid calls.

hm, why does it get called three times?  Is that something which
can/should be fixed in callers rather than in the callee?

