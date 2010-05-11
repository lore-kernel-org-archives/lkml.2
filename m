Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab0EKGfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:35:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43734 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab0EKGfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:35:23 -0400
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, eranian@gmail.com,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>, arjan@linux.intel.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1273523127.25588.33.camel@e200755-lin.cambridge.arm.com>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
	 <1273484401.5605.3333.camel@twins>
	 <1273486313.15998.76.camel@minggr.sh.intel.com>
	 <1273486708.5605.3342.camel@twins>
	 <1273487195.15998.85.camel@minggr.sh.intel.com>
	 <1273490824.5605.3379.camel@twins>  <1273491725.5605.3391.camel@twins>
	 <1273523127.25588.33.camel@e200755-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 11 May 2010 08:34:54 +0200
Message-ID: <1273559694.5605.3412.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 21:25 +0100, Will Deacon wrote:
> Another interesting ARM-ism is the vast potential for uncore event
> sources in SoC devices. The `node' terminology seems a bit confusing
> here, as there may be counters situated at various points of a bus
> hierarchy which monitor various types of transactions for example. I
> suppose these could live under /sys/devices/system/bus/... ?

Right there are more such systems, and yes hooking them into the
appropriate machine topology like PCI busses is exactly the intent.

I already mentioned the GPU PMUs living in the appropriate PCI device.
But yes, there are far more exotic configurations out there.

>  I would
> expect these kind of counters to be controlled via raw events because
> having a list of discrete events doesn't really make sense [for example,
> if I want to count all bursts of a given size, I can encode the burst
> size into the event number]. 

Raw is fine, its only once these things start to converge and show
common traits that adding a 'generic' event class becomes useful, and
this is something that can always be done later.
