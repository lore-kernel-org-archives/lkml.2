Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab1BOCja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 21:39:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58796 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1BOCj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 21:39:26 -0500
Date: Tue, 15 Feb 2011 03:38:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Micha Nelissen <micha@neli.hopto.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add support for multiple MSI on x86
Message-ID: <20110215023847.GF31134@elte.hu>
References: <4D583E31.4070507@neli.hopto.org>
 <20110214123443.GF15860@elte.hu>
 <4D5986DF.8000808@neli.hopto.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5986DF.8000808@neli.hopto.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Micha Nelissen <micha@neli.hopto.org> wrote:

> Ingo Molnar wrote:
> >* Micha Nelissen <micha@neli.hopto.org> wrote:
> >>Patch is based on earlier patch from Matthew Wilcox.
> >
> >Hm, there's an awful lot of 'background', 'implementation',
> >'advantages', 'disadvantages', 'testing' description missing.
> 
> Sorry, my bad, wrong assumption that this would be common knowledge.

When it comes to changes done to a kernel tree used by millions of people then 
common knowledge and mundane details need to be written down, in painstaking detail.

You cannot really err when it comes to details: i've reviewed over a ten thousand 
patches in my life and i've yet to see a single one where the description was too 
verbose ;-)

> PCI devices interrupt the CPU using 'legacy' INTx; or PCI-e devices
> can do a special write, called an MSI (message signaled interrupt).
> The interrupt vector is chosen by the CPU, different devices use
> different vectors so that software can keep the interrupt sources
> separate (instead of using shared INTx "lines").
> 
> Most PCI-e devices support what's called MSI-X, but not all do.
> Especially for FPGA based endpoints it's easier to implement only
> 'regular' MSI support. MSI-X basically involves implementing a
> lookup table that maps interrupt types in the device to interrupt
> vectors for the CPU. 'Regular' MSI (non MSI-X) only supports a
> contiguous block of interrupt vectors: a base vector with a vector
> count (which is a power of 2).
> 
> The x86 code to allocate these interrupt vectors does not handle the
> <> 1 vector count case; it would return that it could only handle 1.
> So either device drivers had 1 MSI, or the device should support
> MSI-X to have multiple interrupts (and handlers) for one device.
> 
> This patch adds the needed code to support multiple MSI per device.
> 
> Advantages: separate interrupt handlers for separate tasks in the
> device. This allows device drivers to be better structured. Easy
> 'diagnostics' due to /proc/interrupts counting number of interrupts
> for separate functionality separately.
> 
> Disadvantages: more complex code due to requirement that it is a
> contiguous block, so needs some effort to look for a free block with
> the requested count.
> 
> Tested: on an Atom platform, with a Xilinx based PCI-e core in FPGA.
> 
> Please review; thanks,

That was a good description, thanks Micha!

	Ingo
