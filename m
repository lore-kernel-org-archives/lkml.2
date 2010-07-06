Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab0GFKUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 06:20:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:56693 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab0GFKUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 06:20:42 -0400
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building
 code out into drivers/of
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andres Salomon <dilinger@queued.net>
Cc: David Miller <davem@davemloft.net>, grant.likely@secretlab.ca,
       devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
       x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       cjb@laptop.org, wmb@laptop.org, pgf@laptop.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100707051548.2c44f30c@debxo>
References: <20100629193618.5a840b8e@dev.queued.net>
	 <AANLkTilme2uAoXjorUEzam9j_xosR8kl70W8PS71d-Th@mail.gmail.com>
	 <20100707040734.05d625af@debxo>
	 <20100705.192221.241453945.davem@davemloft.net>
	 <20100707051548.2c44f30c@debxo>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jul 2010 20:17:33 +1000
Message-ID: <1278411453.1665.273.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Sounds like we have a winner.  I'll concentrate on that, thanks for
> the heads up.

Note that the conversion from OF -> fdt that powerpc does is a bit
"special". The code isn't quite a "wrapper" but almost. It shared pretty
much no symbols or variables with the rest of the kernel.

There are various reasons for that. It has to run -very- early, in fact,
before we do anything else at boot time, since we run off OF existing
environment (stack etc...) at at whatever address the kernel is loaded,
ie. before we relocate it down to 0.

To deal with that, we use compile/linker tricks to generate
pseudo-relocatable code (with limitations) and funny macros when
accessing global symbols.

In addition, we have various workarounds for powerpc specific
implementation issues (OF bugs, but also instanciating the IOMMU tables
on Power4, starting secondary CPUs and parking them in a wait loop,
etc...).

Thus I'm not sure there's that much benefit in trying to make that code
common with other archs, and possibly a lot of pain involved.

Cheers,
Ben.
 

