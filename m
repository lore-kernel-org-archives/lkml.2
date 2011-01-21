Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab1AUTco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 14:32:44 -0500
Received: from mail.openrapids.net ([64.15.138.104]:51283 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754882Ab1AUTcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 14:32:42 -0500
Date: Fri, 21 Jan 2011 14:32:40 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
	this_cpu_cmpxchg_double
Message-ID: <20110121193240.GA13581@Krystal>
References: <alpine.DEB.2.00.1101070907060.3014@router.home> <20110107180419.GB23082@Krystal> <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal> <20110121170847.GH2832@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121170847.GH2832@htj.dyndns.org>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:31:32 up 59 days, 34 min,  4 users,  load average: 0.01, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tejun Heo (tj@kernel.org) wrote:
[...]
> > (note: packed here along with "aligned" does _not_ generate ugly
> > bytewise read/write memory ops like "packed" alone. The use of
> > "packed" is to let the compiler down-align the structure to the
> > value requested, instead of uselessly aligning it on 32-byte if it
> > chooses to.)
> 
> Yeah, good point.  :-)

For the records, I just noticed that "packed, aligned(8)" can generate unaligned
accesses on sparc64 by removing the padding between a "int" and a following
pointer. So we should not use it.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
