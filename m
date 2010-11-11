Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0KKLqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:46:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38710 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755488Ab0KKLqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:46:48 -0500
Date: Thu, 11 Nov 2010 11:46:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the voltage tree
Message-ID: <20101111114644.GC6052@rakim.wolfsonmicro.main>
References: <20101111113638.eb3101d0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111113638.eb3101d0.sfr@canb.auug.org.au>
X-Cookie: Nihilism should commence with oneself.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 11:36:38AM +1100, Stephen Rothwell wrote:

> After merging the voltage tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Oh, a platform where pcap can actually be built!  That's useful, thanks.

> drivers/regulator/pcap-regulator.c:155: error: expected declaration specifiers or '...' before 'unsiged'
> drivers/regulator/pcap-regulator.c: In function 'pcap_regulator_set_voltage':
> drivers/regulator/pcap-regulator.c:175: error: 'selector' undeclared (first use in this function)
> drivers/regulator/pcap-regulator.c: At top level:
> drivers/regulator/pcap-regulator.c:251: warning: initialization from incompatible pointer type

> Caused by commit d2f03ebfe8c63d1e3e1ab2352dd32d161546003e ("regulator:
> Report actual configured voltage to set_voltage()").  Please always build
> changed files ...

With a lot of the embedded drivers that can be difficult - often there
are dependencies on APIs that are only available on a small set of
platforms (which may not even be documented).  For example, with PCAP
the core driver uses irq_to_gpio() which is not implemented on any of
the platforms I commonly build for.
