Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1DJGCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 02:02:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55464 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab1DJGCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 02:02:10 -0400
Date: Sun, 10 Apr 2011 08:01:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH v2] x86/mrst: correct pin to irq mapping
Message-ID: <20110410060154.GA24684@elte.hu>
References: <1302286980-21139-1-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302286980-21139-1-git-send-email-jacob.jun.pan@linux.intel.com>
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


* Jacob Pan <jacob.jun.pan@linux.intel.com> wrote:

> As a result, apbt timer and RTC interrupts on Moorestown are within legacy
> IRQ range.
> 
> sh-3.2# cat /proc/interrupts
>            CPU0       CPU1
>   0:      11249          0   IO-APIC-edge      apbt0
>   1:          0      12271   IO-APIC-edge      apbt1
>   8:        887          0   IO-APIC-fasteoi   dw_spi
>  13:          0          0   IO-APIC-fasteoi   INTEL_MID_DMAC2
>  14:          0          0   IO-APIC-fasteoi   rtc0

Is there a 'before the patch' /proc/interrupts output as well? Supposedly it's 
different and seeing that different output is *way* more descriptive to the 
casual commit log reader than a textual explanation only.

Also, i guess this would be .40 material, right?

Thanks,

	Ingo
