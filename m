Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0HSJpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 05:45:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:33869 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab0HSJpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 05:45:18 -0400
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Zhang Rui <rui.zhang@intel.com>, "Lin, Ming M" <ming.m.lin@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <20100819083218.GB25755@console-pimps.org>
References: <1282118350.5181.115.camel@rui>
	 <1282134329.1926.3918.camel@laptop>
	 <20100818124116.GA17957@console-pimps.org>
	 <1282188497.11858.94.camel@minggr.sh.intel.com>
	 <20100819075410.GA25755@console-pimps.org> <1282206714.5181.552.camel@rui>
	 <20100819083218.GB25755@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 Aug 2010 11:44:45 +0200
Message-ID: <1282211085.1926.4598.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 09:32 +0100, Matt Fleming wrote:
> 
> 
> How big is the hardware counter? The problem comes when the process is
> scheduled in and runs for a long time, e.g. so long that the energy
> hardware counter wraps. This is why it's necessary to periodically
> sample the counter.
> 
Long running processes aren't the only case, you could associate an
event with a CPU.

Right, short counters (like SH when not chained) need something to
accumulate deltas into the larger u64. You can indeed use timers for
that, hr or otherwise, but you don't need the swcounter hrtimer
infrastructure for that.
