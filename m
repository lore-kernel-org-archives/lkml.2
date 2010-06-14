Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab0FNQjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:39:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61235 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab0FNQjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:39:32 -0400
Subject: Re: [PATCH] mtd: Fix bug using smp_processor_id() in preemptible
 ubi_bgt1d kthread
From: Philby John <pjohn@mvista.com>
Reply-To: pjohn@mvista.com
To: Jamie Lokier <jamie@shareable.org>
Cc: linux-mtd@lists.infradead.org, linux-mips@linux-mips.org,
       David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
       Artem Bityutskiy <dedekind1@gmail.com>
In-Reply-To: <20100614150425.GC9550@shareable.org>
References: <1276513457.16642.3.camel@localhost.localdomain>
	 <20100614150425.GC9550@shareable.org>
Content-Type: text/plain
Date: Mon, 14 Jun 2010 22:10:18 +0530
Message-Id: <1276533618.17818.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 16:04 +0100, Jamie Lokier wrote:
> Philby John wrote:
> > mtd: Fix bug using smp_processor_id() in preemptible ubi_bgt1d kthread
> > 
> > On a MIPS Cavium Octeon CN5020 when trying to create a UBI volume,
> > on the NOR flash, the kernel thread ubi_bgt1d calls
> > cfi_amdstd_write_buffers() --> do_write_buffer() -->
> > INVALIDATE_CACHE_UDELAY --> __udelay(). Its __udelay() that calls
> > smp_processor_id() in preemptible code, which you are not supposed to.
> > Fix the problem by disabling preemption.
> 
> The MTD code just calls udelay().
> Are you sure it isn't permitted to call udelay() from preemptible code?
> I think it is fine.

It isn't really udelay() but smp_processor_id() that you are not to call
from a preemptible thread. Now I also see Ed Swierk has done a similar
thing https://patchwork.kernel.org/patch/4049/ and he comments "..which
calls smp_processor_id(), which is not supposed to be called from a
preemptible thread."


So perhaps I can use preempt_disable() around just this call in function
__udelay()?

Regards,
Philby

