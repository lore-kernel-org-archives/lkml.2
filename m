Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab0FOMZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:25:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37944 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0FOMZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:25:48 -0400
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
Date: Tue, 15 Jun 2010 17:56:34 +0530
Message-Id: <1276604794.19810.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jamie,

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
> 
> Perhaps MIPS udelay() should be disabling preemption itself, or
> (as x86 does) using raw_smp_processor_id() instead?

Sorry for the noise. I now find that raw_smp_processor_id() has been
implemented specific to MIPS in the latest kernel, I was using 2.6.32.

Thanks and regards,
Philby

