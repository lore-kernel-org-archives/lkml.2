Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab0KRNRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:17:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:59039 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab0KRNRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:17:41 -0500
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4CE52048.5080802@windriver.com>
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
	 <4CDD579F.80009@windriver.com> <20101112154231.GN4823@redhat.com>
	 <4CDD6389.2080206@windriver.com> <20101112161144.GP4823@redhat.com>
	 <4CDD6CAD.30303@windriver.com> <20101112172755.GR4823@redhat.com>
	 <20101116184325.GB4823@redhat.com> <4CE2E3C3.6060800@windriver.com>
	 <20101118080516.GJ32621@elte.hu>  <4CE52048.5080802@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Nov 2010 14:17:12 +0100
Message-ID: <1290086232.2109.1507.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-18 at 06:47 -0600, Jason Wessel wrote:
> More specifically
> when another subsystem injects an NMI event the perf NMI code returns
> NOTIFY_STOP. 

Not unconditionally, right? We only do so when the previous NMI was from
the PMU and nobody claimed this one (NOTIFY_STOP from DIE_NMIUNKNOWN).

Or are you hitting the other one, where !handled but pmu_nmi.handled >
1 ?
