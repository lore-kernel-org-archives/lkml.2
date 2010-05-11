Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab0EKGjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:39:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51706 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab0EKGjK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:39:10 -0400
Subject: Re: [RFC][PATCH 2/9] perf: core, remove hw_perf_event_init
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100510230911.GB5895@nowhere>
References: <1273483595.15998.56.camel@minggr.sh.intel.com>
	 <1273484430.5605.3334.camel@twins>
	 <1273486670.15998.80.camel@minggr.sh.intel.com>
	 <1273486769.5605.3343.camel@twins> <20100510122728.GB5563@nowhere>
	 <1273496054.5605.3400.camel@twins>  <20100510230911.GB5895@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 11 May 2010 08:38:55 +0200
Message-ID: <1273559935.5605.3418.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 01:09 +0200, Frederic Weisbecker wrote:

> Which module do you have in mind that could register a pmu?
> And I don't understand the problem with pci-hotplug.

Well, the DRM drivers for one, but basically the trend is for every
aspect of the machine to include PMUs of some form, this includes bus
bridges and fancy devices.

The point about PCI-hotplug is that GPUs live on the PCI bus and once
they start adding their PMU drivers we need to be able to unplug them.

Same for when the PCI bridge devices start featuring PMU
implementations.
