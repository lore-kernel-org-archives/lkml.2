Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1FCOmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:42:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:49213 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab1FCOmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:42:03 -0400
Subject: Re: [PATCH v1 5/5] KVM: Expose a version 1 architectural PMU to
 guests
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <1305129333-7456-6-git-send-email-avi@redhat.com>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
	 <1305129333-7456-6-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Jun 2011 16:41:51 +0200
Message-ID: <1307112111.2353.3390.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 11:55 -0400, Avi Kivity wrote:
> - counters that have PMI (interrupt) enabled stop counting after the
>   interrupt is signalled.  This is because we need one-shot samples
>   that keep counting, which perf doesn't support yet 

You'll have to reprogram the thing anyway, since not all hardware has
the same counter width:

[    0.046996] Performance Events: AMD PMU driver.
[    0.048998] ... bit width:              48

vs

[    0.026998] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.026998] ... bit width:              40

simply letting the thing run will not behave in a consistent fashion.

Or are you going to assume all software will properly read the cpuid
leaf and not assume bit width?

Also, I can't seem to locate where you fill that cpuid-leaf,
kvm_pmu_cpuid_update() seems to read the entry, not write it.
