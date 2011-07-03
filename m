Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab1GCTqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 15:46:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55067 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab1GCTqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 15:46:45 -0400
Date: Sun, 3 Jul 2011 21:46:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary
 physical addresses
Message-ID: <20110703194618.GB27022@elte.hu>
References: <201106171038.25988.ptesarik@suse.cz>
 <201107012134.45881.ptesarik@suse.cz>
 <20110701195629.GA19057@elte.hu>
 <201107012244.57593.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107012244.57593.ptesarik@suse.cz>
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


* Petr Tesarik <ptesarik@suse.cz> wrote:

> > Do you expect distros to enable this boot option by default? I.e. 
> > would SuSE be willing to ship with a restrictive /dev/mem by 
> > default? That's really the wider goal we want to work towards.
> 
> I'm not really the decision-maker on this, but even though I don't 
> need it for crash, there are several other users which would have 
> to be fixed:
> 
> 1. hwinfo (EFI, MPTABLE and ACPI table parsing, analyzing video BIOS)
> 2. dmidecode (SMBIOS, DMI)
> 3. possibly others

But those tables wont be in regular RAM (they will be in ROM or in 
RAM marked non-RAM in a special way in the e820 tables).

dmidecode certainly works on Fedora.

> > Hm, why would the ability "dirty and/or flush an arbitrary 
> > physical cache line for testing purposes" be a DoS?
> 
> Effectively switching off CPU caches can slow things down quite a 
> bit... especially on a large SMP system. ;)

Flushing a cacheline isnt switching it off. You can already 'flush' 
the cache from user-space as well, by trashing it for example. So i 
don't see the DoS angle.

Thanks,

	Ingo
