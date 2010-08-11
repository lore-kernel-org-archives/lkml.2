Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0HKMj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 08:39:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab0HKMj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 08:39:58 -0400
Date: Wed, 11 Aug 2010 08:39:37 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100811123937.GB4879@redhat.com>
References: <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100810204856.GA16571@redhat.com>
 <20100811024451.GA26835@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811024451.GA26835@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 04:44:55AM +0200, Frederic Weisbecker wrote:
> May be make it just a pending bit. I mean not something that can
> go further 1, because you can't have more than 1 pending anyway. I don't
> know how that could happen you get accidental perctr_skip > 1, may be
> expected pending NMIs that don't happen somehow, but better be paranoid with
> that, as it's about trying not to miss hardware errors.

I guess I was thinking about the SMI case where it drains the perfctr(s)
and then retriggers them but I guess even in that case the most you can
have is one extra NMI.  So yeah, you are probably right, I should have
used a flag instead of incrementing.

Cheers,
Don
