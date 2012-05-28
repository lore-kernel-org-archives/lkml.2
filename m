Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2E1Jrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:47:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:54508 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2E1Jri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:47:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="171943555"
Message-ID: <4FC349B7.2090101@linux.intel.com>
Date: Mon, 28 May 2012 17:47:35 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        tony.luck@intel.com, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel machines
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <20120525062426.GB3179@aftab.osrc.amd.com>
In-Reply-To: <20120525062426.GB3179@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/5/25 14:24, Borislav Petkov 写道:
> On Thu, May 24, 2012 at 05:54:52PM +0000, Thomas Gleixner wrote:
>> Intentionally left blank to be filled out by someone who wants
>> that and can explain the reason for this better than me.
> 
> That'll be Intel folk :)
> 
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Looks good to me too, thanks Thomas for doing this!
> 
> I'll run it next week just in case.
> 
> Acked-by: Borislav Petkov <borislav.petkov@amd.com>
> 
Hi, Boris

Have you tested Thomas' patch. During my test, it hangs in below 2
scenarios:

1) remove sb_edac driver, and then inject error, hang right now!
2) keep sb_edac drivr, inject error until storm happens (I changed
the condition from 1 HZ to 1 minute to make it easy to trigger
storm), after 5 errors are injected, codes enter *storm* mode,
but hang right now again!

At least, scenario 2 has direct connection with new patches. I
need time to investigate because no any output after hang. (lockdep?)


