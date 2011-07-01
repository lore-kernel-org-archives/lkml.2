Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1GANsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:48:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38138
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756463Ab1GANsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:48:19 -0400
Date: Fri, 1 Jul 2011 09:47:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Petr Tesarik <ptesarik@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
Message-ID: <20110701134705.GA6175@infradead.org>
References: <201106171038.25988.ptesarik@suse.cz>
 <20110617093032.GA19235@elte.hu>
 <201106291106.00070.ptesarik@suse.cz>
 <20110701125802.GE12605@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701125802.GE12605@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 02:58:02PM +0200, Ingo Molnar wrote:
> So what was not mentioned in your series, what is *your* motivation 
> and your usecase? Enabling closed-source userspace drivers? Enabling 
> the crash utility?

He stated it pretty clearly in the thread, it's the crash utility.

> 
> If the former then shame on you, if the latter then how do you 
> explain that distros appear to disable the RAM aspect of /dev/mem:
> 
>  $ grep DEVMEM $(rpm -ql kernel-2.6.38-0.rc7.git2.3.fc16.x86_64 | grep config-2.6 )
>  CONFIG_STRICT_DEVMEM=y
> 
> So the crash utility use-case does not work on unpatched, default 
> kernels, right?

Not if you have highmem.  That's why Redhat or Fedora to quote your
example patch in the /dev/crash driver, which totally defeats the
CONFIG_STRICT_DEVMEM setting.  But apparently it's good enough that no
one either noticed or at least doesn't care.

