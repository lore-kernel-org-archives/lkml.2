Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab0LPIe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 03:34:59 -0500
Received: from www.tglx.de ([62.245.132.106]:46545 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab0LPIe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 03:34:58 -0500
Date: Thu, 16 Dec 2010 09:34:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Robin@sgi.com, "Holt <holt"@sgi.com
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 2/2] Make x86 calibrate_delay run in parallel.
In-Reply-To: <20101215015849.051095242@gulag1.americas.sgi.com>
Message-ID: <alpine.LFD.2.00.1012160930010.12146@localhost6.localdomain6>
References: <20101215015840.390204279@gulag1.americas.sgi.com> <20101215015849.051095242@gulag1.americas.sgi.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010, Robin@sgi.com wrote:
> On a 4096 cpu machine, we noticed that 318 seconds were taken for bringing
> up the cpus.  By specifying lpj=<value>, we reduced that to 75 seconds.
> Andi Kleen suggested we rework the calibrate_delay calls to run in
> parallel.  With that code in place, a test boot of the same machine took
> 61 seconds to bring the cups up.  I am not sure how we beat the lpj=
> case, but it did outperform.

If you know that all cpus are running at the same speed, then you can
set lpj=firstcpu and juts calibrate the first cpu and take the value
for all others.

> One thing to note is the total BogoMIPS value is also consistently higher.
> I am wondering if this is an effect with the cores being in performance
> mode.  I did notice that the parallel calibrate_delay calls did cause the

We really to know that. I mean the change from:

> bogomips	: 4532.81
> bogomips	: 4532.65
> bogomips	: 4532.64
> bogomips	: 4532.64

to

> bogomips	: 4533.49
> bogomips	: 7890.05
> bogomips	: 9699.67
> bogomips	: 10047.13

looks strange. The deviation is more than factor 2 and this is on the
same socket. So before we push that into the tree we better know
what's going on.

Thanks,

	tglx

