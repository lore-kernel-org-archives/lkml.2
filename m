Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2JIPm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:42:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:54741 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab2JIPm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:42:28 -0400
Message-ID: <1349797304.7880.70.camel@twins>
Subject: Re: [PATCH] x86/perf: Fix virtualization sanity check
From: Peter Zijlstra <peterz@infradead.org>
To: Andre Przywara <andre.przywara@amd.com>
Cc: mingo@elte.hu, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org
Date: Tue, 09 Oct 2012 17:41:44 +0200
In-Reply-To: <1349797115-28346-1-git-send-email-andre.przywara@amd.com>
References: <1349797115-28346-1-git-send-email-andre.przywara@amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 17:38 +0200, Andre Przywara wrote:
> First you need an AMD family 10h/12h CPU. These do not reset the
> PERF_CTR registers on a reboot.
> Now you boot bare metal Linux, which goes successfully through this
> check, but leaves the magic value of 0xabcd in the register. You
> don't use the performance counters, but do a reboot (warm reset).
> Then you choose to boot Xen. The check will be triggered with a
> recent Linux kernel as Dom0 again, trying to write 0xabcd into the
> MSR. Xen silently drops the write (expected), but the subsequent read
> will return the value in the register, which just happens to be the
> expected magic value. Thus the test misleadingly succeeds, leaving
> the kernel in the belief that the PMU is available 

Wow.. ! that's uhm.. shees!

Bit weird of Xen to trap writes but not reads of MSRs though.

The patchs looks fine though, thanks!
