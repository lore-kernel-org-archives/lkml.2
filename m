Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117Ab0KRUEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:04:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:42916 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681Ab0KRUE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:04:29 -0500
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4CE583D0.8050407@windriver.com>
References: <20101112154231.GN4823@redhat.com>
	 <4CDD6389.2080206@windriver.com> <20101112161144.GP4823@redhat.com>
	 <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com>
	 <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com>
	 <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com>
	 <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com>
	 <4CE583D0.8050407@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Nov 2010 21:04:20 +0100
Message-ID: <1290110660.2109.1529.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 13:51 -0600, Jason Wessel wrote:
> I highly doubt we want to disable perf.   I would rather use the source
> and fix the nmi emulation in KVM/Qemu after we hear back the results
> from Cyril because it sounds as if the problem is nearly bottomed out.

Problem is that p6/p4/amd don't have cpuid bits telling us if there is a
PMU (virt should clear those if it doesn't emulate one).

I guess the safest course is to write a pmu msr and see if that faults,
if it does, disable the thing.


