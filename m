Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2CLRZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:25:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54470 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab2CLRZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:25:16 -0400
Message-ID: <1331546307.18960.26.camel@twins>
Subject: Re: [PATCH] Fix the race between smp_call_function and CPU booting
From: Peter Zijlstra <peterz@infradead.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Date: Mon, 12 Mar 2012 10:58:27 +0100
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 09:27 +0000, Liu, Chuansheng wrote:
> The solution is just to send smp call to active cpus instead of online
> cpus.

BTW, that solution is broken because !active cpus can still be online
and actually running stuff, so sending IPIs to them is perfectly fine
and actually required.


