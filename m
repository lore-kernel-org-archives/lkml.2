Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1EYG7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 02:59:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55123 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab1EYG7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 02:59:45 -0400
Date: Wed, 25 May 2011 08:59:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] x86, intel: Use cpu_update for Atom errata check
Message-ID: <20110525065918.GD429@elte.hu>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <1306278210-18285-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306278210-18285-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Now that the cpu update level is available the Atom PSE errata
> check can use it directly without reading the MSR again.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/intel.c |   15 ++++-----------

Ok, it's nice that you have split this one out.

Please also split out the MCE printk change you did in the first patch - even 
if it's a oneliner we want the first patch to only include changes focused to 
the primary purpose alone: the introduction of x86_cpu::microcode_version.

Also, please split the first patch into two other parts: a first one that 
factors out the Intel microcode-version MSR function into a separate function, 
and the second patch that introduces the x86_cpu::microcode_version field and 
fills it in in the CPU detection code and keeps it updated in the microcode 
driver.

Thanks,

	Ingo
