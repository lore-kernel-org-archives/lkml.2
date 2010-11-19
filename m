Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab0KSSZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:25:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:46560 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab0KSSZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:25:51 -0500
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20101119165952.GJ18100@redhat.com>
References: <20101112172755.GR4823@redhat.com>
	 <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com>
	 <20101118080516.GJ32621@elte.hu> <4CE52048.5080802@windriver.com>
	 <1290086232.2109.1507.camel@laptop> <20101118193247.GF18100@redhat.com>
	 <4CE583D0.8050407@windriver.com> <20101118200807.GC8131@redhat.com>
	 <1290112234.2109.1534.camel@laptop>  <20101119165952.GJ18100@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 19:25:58 +0100
Message-ID: <1290191158.2109.1614.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 11:59 -0500, Don Zickus wrote:
> Reading the kvm code in arch/x86/kernel/kvm/x86.c, it seems like they do
> _not_ fault on writes, only on some (which don't include a bunch of the
> perfctrs).  The reason seems to be to prevent older distros from falling
> apart that could not handle those faults properly.

Egads, that's just vile.. in that case we don't really need to do
anything, its a qemu/KVM bug, they emulate non-working hardware.

Hmm,. there is something we can do though, write a non-zero counter
value and then read it back, if its not what we wrote, its fudged and we
disable the pmu.


