Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab2HTPsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:48:01 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:53771 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266Ab2HTPr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:47:56 -0400
Date: Mon, 20 Aug 2012 15:47:54 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Alex Shi <alex.shi@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
In-Reply-To: <502CFC41.1030501@linux.intel.com>
Message-ID: <0000013944b80714-c594cc1e-de63-4901-9aa7-0b5a3d8629e5-000000@email.amazonses.com>
References: <5028F12C.7080405@intel.com> <20120815161911.GA14534@srcf.ucam.org> <502C7F24.6020900@intel.com> <502CFC41.1030501@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One issue that is often forgotten is that there are users who want lowest
latency and not highest performance. Our systems sit idle for most of the
time but when a specific event occurs (typically a packet is received)
they must react in the fastest way possible.

On every new generation of hardware and software we keep on running into
various mechanisms that automatically power down when idle for a long time
(to save power...). And its pretty hard to figure these things out given
the complexity of modern hardware. F.e. for the Sandybridges we found that
the memory channel powers down after 2 milliseconds idle time and that was
unaffected by any of the bios config options. Similar mechanisms exist in
the kernel but those are easier discover since there is source.

So please make sure that there are obvious and easy ways to switch this
stuff off or provide "low latency" know that keeps the system from
assuming that idle time means that full performance is not needed.

