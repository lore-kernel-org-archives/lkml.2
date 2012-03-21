Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab2CUJMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:12:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:46379 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2CUJMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:12:17 -0400
Message-ID: <1332321124.18960.471.camel@twins>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Wed, 21 Mar 2012 10:12:04 +0100
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A05B485@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
	 <1331654251.18960.78.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
	 <1331718197.18960.106.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A056F47@SHSMSX101.ccr.corp.intel.com>
	 <1331808391.18960.160.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05806B@SHSMSX101.ccr.corp.intel.com>
	 <1331891364.18960.221.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A058AAE@SHSMSX101.ccr.corp.intel.com>
	 <1332151397.18960.252.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05A6BF@SHSMSX101.ccr.corp.intel.com>
	 <1332245842.18960.413.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A05B485@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 05:59 +0000, Liu, Chuansheng wrote:
> Could you consider the advice that setting the active just after set
> online?

Not until I understand why the current stuff explodes, also see
fd8a7de17 setting active after online can re-introduce that problem.

Which ever way I need to clean up some archs since there's all kind of
broken in there.
