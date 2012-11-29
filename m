Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2K2VGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:06:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:35161 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab2K2VGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:06:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,186,1355126400"; 
   d="scan'208";a="255238718"
Message-ID: <50B7CE4C.80201@linux.intel.com>
Date: Thu, 29 Nov 2012 13:06:20 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mario Gzuk <mariogzuk@technikz.de>
Subject: Re: [PATCH 8/8] x86, cleanups: Simplify sync_core() in the case of
 no CPUID
References: <1354132230-21854-1-git-send-email-hpa@linux.intel.com> <1354132230-21854-9-git-send-email-hpa@linux.intel.com> <20121128204158.GC14635@liondog.tnic> <50B6A8F3.5000407@zytor.com> <20121129091317.GA21084@liondog.tnic>
In-Reply-To: <20121129091317.GA21084@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 01:13 AM, Borislav Petkov wrote:
> 
> RCX gets correctly cleaned to 0 and *then* we call CPUID.
> 
> And the asm output is the same except that RCX gets correctly cleaned up
> before calling CPUID.
> 
> So what am I missing?
> 

It doesn't matter in that context, as the surrounding MSR references
have barriers, but what I'm refering to is the "memory" barrier.

The value of ECX doesn't matter when EAX=1.

	-hpa


