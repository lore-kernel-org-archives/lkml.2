Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2DPTRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:17:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:7458 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab2DPTRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:17:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="142422880"
Date: Mon, 16 Apr 2012 21:26:41 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH] mfd: fix modular builds of rc5t583 regulator support
Message-ID: <20120416192641.GB24130@sortiz-mobl>
References: <1334549301-32114-1-git-send-email-paul.gortmaker@windriver.com>
 <4F8BC20A.2090105@nvidia.com>
 <4F8C28C5.9070308@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8C28C5.9070308@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul, Laxman,

On Mon, Apr 16, 2012 at 10:12:21AM -0400, Paul Gortmaker wrote:
> On 12-04-16 02:54 AM, Laxman Dewangan wrote:
> > On Monday 16 April 2012 09:38 AM, Paul Gortmaker wrote:
> >> The combination of commit 1b1247dd75aa5cf5fae54a3bec7280046e9c7957
> >>
> >>      "mfd: Add support for RICOH PMIC RC5T583"
> >>
> >> and commit 6ffc3270210efa2bea526953a142ffc908f5bd86
> >>
> >>      "regulator: Add support for RICOH PMIC RC5T583 regulator"
> >>
> >> are causing the i386 allmodconfig builds to fail with this:
> >>
> >>    ERROR: "rc5t583_update" [drivers/regulator/rc5t583-regulator.ko] undefined!
> >>    ERROR: "rc5t583_set_bits" [drivers/regulator/rc5t583-regulator.ko] undefined!
> >>    ERROR: "rc5t583_clear_bits" [drivers/regulator/rc5t583-regulator.ko] undefined!
> >>    ERROR: "rc5t583_read" [drivers/regulator/rc5t583-regulator.ko] undefined!
> >>
> >> and this:
> >>
> >>    ERROR: "rc5t583_ext_power_req_config" [drivers/regulator/rc5t583-regulator.ko] undefined!
> >>
> >> For the 1st four, make the simple ops static inline, instead of
> >> polluting the namespace with trivial exports.  For the last one,
> >> add an EXPORT_SYMBOL.
> >>
> >> Signed-off-by: Paul Gortmaker<paul.gortmaker@windriver.com>
> >> ---
> >>
> >> [ alternately, make REGULATOR_RC5T583 bool instead of tristate? ]
> > 
> > Why not export all require symbol from mfd core.
> > I am sending the patch to exporting all required apis. Please review.
> 
> As I said in the commit log, it doesn't seem to make sense to export
> them when they are trivial enough to be static inline, since it
> avoids having them pollute the /proc/kallsyms namespace.
I'm applying Paul's patch to my for-linus branch, thanks guys.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
