Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab0IBG5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 02:57:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55070 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab0IBG5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 02:57:42 -0400
Date: Thu, 2 Sep 2010 08:57:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] [arch-x86] Allow SRAT integrity check to be skipped
Message-ID: <20100902065731.GB29972@elte.hu>
References: <20100901213318.19353.54619.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100901213318.19353.54619.stgit@localhost.localdomain>
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


* Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com> wrote:

> On certain BIOSes, SRAT enumeration isn't exported correctly. This 
> leads to NUMA node enumeration failure, and causes the kernel to fall 
> back onto a single node treated as flat memory.  This can happen on 
> large, multi-socket systems (4 or more sockets), and becomes 
> problematic for performance.
> 
> This patch adds a boot parameter to allow a kernel to be booted with 
> the option to skip the SRAT check.  There are BIOSes in production 
> that have these failures, so this will allow people in the field to 
> work around these BIOS issues.

> + 	sratbypassbios
> +		If specified, will skip an SRAT check for PXM coverage
> +		from BIOS enumeration.  Only to be used on systems with
> +		buggy BIOSes that munge the SRAT enumeration.

This isnt a particularly useful solution to users of said systems - they 
have to figure out that this option exists, and then they have to enter 
this option on the boot line.

A better solution would be to match these systems using DMI filters - 
_and_ to also have the boot time option to cover the case where a new 
system comes out with such a breakage. (or there's some system not yet 
mapped)


	Ingo
