Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0H3MzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:55:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36902 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0H3MzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:55:24 -0400
Subject: Re: [RFC][PATCH 3/5] perf: Add hrtimer code for PMI-less hardware
 counters
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <38d993baf1328403d9a1c4a2f012c4aa0e19feab.1283123521.git.matt@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
	 <38d993baf1328403d9a1c4a2f012c4aa0e19feab.1283123521.git.matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 30 Aug 2010 14:55:02 +0200
Message-ID: <1283172902.1820.897.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 13:13 +0100, Matt Fleming wrote:
> Currently, it's impossible to periodically sample hardware counters that
> lack performance monitoring interrupt (PMI) support. In order to sample
> these counters we can create an event group which is backed by a
> hrtimer, thereby simulating a PMI.
> 
> When the hrtimer goes off we sample the values in the hardware
> counters. Because we obviously can't rely on the hrtimer going off at
> exactly the sample period (say, every 1000 cache misses) the values need
> to be weighted by the variable period since the last hrtimer went
> off. This is so that we can compensate for the variability in hrtimer
> period.
> 
> If perf record tries to create a sampling counter and the hardware
> doesn't support it then we'll fall back to creating an event group with
> a hrtimer.


Why is this changing kernel code?

You can create those groups in userspace..
