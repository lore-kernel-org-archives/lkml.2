Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab1LAODv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:03:51 -0500
Received: from gate.crashing.org ([63.228.1.57]:52800 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab1LAODu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:03:50 -0500
Subject: Re: Different behaviour when using "nosmp" parameter on SMP and UP
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <CAL8zT=juU_PC92R4za31R8Lmur0PrFwog1m1fk+PEarW_0C6ng@mail.gmail.com>
Date: Thu, 1 Dec 2011 08:03:42 -0600
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D70E8CC4-9FA3-4DC9-B623-02F32EFBFE0F@kernel.crashing.org>
References: <CAL8zT=juU_PC92R4za31R8Lmur0PrFwog1m1fk+PEarW_0C6ng@mail.gmail.com>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 1, 2011, at 3:57 AM, Jean-Michel Hautbois wrote:

> Hi,
> 
> I have a P2020 CPU (powerpc) and I compiled it with two different defconfigs.
> The first one is a SMP, 2 cores, launched with the "nosmp" kernel
> parameter, the other one is an UP kernel.
> 
> My driver behaviour is not the same whether launching one or the
> other. It is hard to explain more precisely, as it deals only with
> ioctl which only does ioread32/iowrite32 on a PCIe device.
> But I can tell that it never works the same way when UP (not working
> correctly), or SMP "nosmp" (working) or even SMP (not working).
> 
> AFAIK, the "nosmp" parameter should tell the kernel to act the same is
> if it is an UP kernel, and it disables IO APIC, which is not an issue
> in my case.
> 
> Can you think about anything that would explain it, or would help me
> debugging it ?

This is a bit odd, hard to say w/o more details on what exactly your code is trying to do and wait the failure is.

The larger differences between SMP & UP build would be setting of memory attribute for cache coherency.  In UP case we don't set it.

Between SMP 'nosmp' and SMP 'on' cases you seem like you're hitting some locking condition.

Guessing your running into a timing & locking issue that you're getting lucky on the SMP 'nosmp' case such that it just happens to work.

- k