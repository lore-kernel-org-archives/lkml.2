Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252Ab1D0NOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:14:16 -0400
Received: from mx0.aculab.com ([213.249.233.131]:54090 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754522Ab1D0NOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:14:15 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V4] POWER: perf_event: Skip updating kernel counters if register value shrinks
Date: Wed, 27 Apr 2011 14:13:25 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AD06@saturn3.aculab.com>
In-Reply-To: <20110427130822.GC2936@mgebm.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V4] POWER: perf_event: Skip updating kernel counters if register value shrinks
Thread-Index: AcwE3BmjfJHFwnUgS6e4tmDp7cu0FwAAFuAQ
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric B Munson" <emunson@mgebm.net>
Cc: <benh@kernel.crashing.org>, <a.p.zijlstra@chello.nl>, <paulus@samba.org>,
        <mingo@elte.hu>, <acme@ghostprotocols.net>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <anton@samba.org>, <stable@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> prev and val are both 64 bit variables holding 32 bit numbers, we do
not
> accumulate in either, they are both replaced by values directly from
the
> registers.
> So prev > val will not always be true.

The code seems to be:
    prev = local64_read(&event->hw.prev_count);
    val = read_pmc(event->hw.idx);
    delta = check_and_compute_delta(prev, val);
    local64_add(delta, &event->count);
Which looks very much like 'prev' being a 64bit counter generated
from the 32bit pmc register.

	David


