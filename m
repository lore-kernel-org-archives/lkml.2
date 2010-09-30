Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab0I3AsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 20:48:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:24413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0I3AsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 20:48:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,257,1283756400"; 
   d="scan'208";a="559214941"
Subject: Re: high power consumption in recent kernels
From: "Alex,Shi" <alex.shi@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "efault@gmx.de" <efault@gmx.de>, "Li, Shaohua" <shaohua.li@intel.com>,
        tglx <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>
In-Reply-To: <4CA34F95.30400@logic.at>
References: <1284355277.26157.8109.camel@debian>
	 <1284689374.17745.89.camel@debian> <1283840425.26157.6486.camel@debian>
	 <20100909093140.GC29648@gamma.logic.tuwien.ac.at>
	 <EA929A9653AAE14F841771FB1DE5A1366008738EC2@rrsmsx501.amr.corp.intel.com>
	 <20100909205115.GD11053@gamma.logic.tuwien.ac.at>
	 <1284107099.402.30.camel@laptop>
	 <6E3BC7F7C9A4BF4286DD4C043110F30B2991AF14FD@shsmsx502.ccr.corp.intel.com>
	 <20100910145451.GB21450@gamma.logic.tuwien.ac.at>
	 <1284355277.26157.8109.camel@debian>
	 <20100922154452.GA9080@gamma.logic.tuwien.ac.at>
	 <1285670426.21962.43.camel@debian>  <4CA34F95.30400@logic.at>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 08:50:41 +0800
Message-ID: <1285807841.21962.1147.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 22:39 +0800, Norbert Preining wrote:
> Hi Alex,
> 
> > Could you like to try the following patch on your system and see how
> > many power it consumption now?
> 
> But this patch is excately what you send me already and what I tried
> and I answered in the last email?
> 
> Do I miss something here?
> 
> All the best
> 
> Norbert
The following line is different, the new code remove the nohz_ratelimit
from irq_exit(). That may resolve your system too many interrupts
issue. 

+               arch_needs_cpu(cpu)|| (inidle && nohz_ratelimit(cpu))) {


