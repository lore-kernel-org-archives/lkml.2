Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab1F1Kjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:39:45 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46778 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab1F1Ki7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:38:59 -0400
Subject: Re: x86, perf, pmu: make reserve_ds_buffers() allocate memory
 dynamically
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: eranian@google.com, fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20110624160143.GA29969@redhat.com>
References: <20110624160143.GA29969@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 28 Jun 2011 12:38:01 +0200
Message-ID: <1309257481.6701.192.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 12:01 -0400, Don Zickus wrote:
> Hi guys,
> 
> Some kdump folks noticed that on large machines (say 80 cpu threads), the
> kernel reserved a good chunk of memory in the kdump kernel with the call
> to reserve_ds_buffers(). About 64k per cpu.
> 
> Normally the kdump kernel boots with maxcpus=1 to limit the amount of
> processing and memory usage it needs.  However, with reserve_ds_buffers()
> it seems to allocate a giant chunk of memory due to its use of
> for_each_possible_cpu().
> 
> I was wondering if it was possible to move some of that allocation to the
> cpu_prepare/cpu_starting routines and allocate during a cpu hotplug event.
> I am not sure if some of this allocation is on a per cpu basis (which
> includes multiple cores) or if there is some sort of other restriction
> that required the code to be statically allocated at boot time.

The only complication I can remember is that the BTS buffers are an
order 4 allocation, so the later you allocate them the less likely they
are to be available.

Other than that there isn't anything magical about any of it.
