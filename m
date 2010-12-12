Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab0LLSlH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 13:41:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45444 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753455Ab0LLSlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 13:41:06 -0500
Date: Sun, 12 Dec 2010 18:41:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] gpiolib: Convert ADP5588 to new irq_ APIs
Message-ID: <20101212184115.GA19583@opensource.wolfsonmicro.com>
References: <1292159988-28268-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <AANLkTi=x3Y7-eOPXg42=sj44LAUXE0EnrbxmvRCyKQeo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=x3Y7-eOPXg42=sj44LAUXE0EnrbxmvRCyKQeo@mail.gmail.com>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 11:33:27AM -0500, Mike Frysinger wrote:
> On Sun, Dec 12, 2010 at 08:19, Mark Brown wrote:

> > The genirq core is being updated to pass struct irq_data to irq_chip
> > operations instead of an irq number. Update the ADP5588 GPIO driver to
> > the new API.

> "is being updated" ... does that mean it hasnt been merged yet and so
> this patch depends on something else ?

No dependency.  The change is being staged in gradually so from 2.6.37
both APIs are available unless the architecture explicitly selects a
Kconfig symbol which disables the old one (SH is trying to do this now
but I'm hopeful that Paul will update this for 2.6.37 so GPIO and MFD
drivers aren't affected in that release).  At some point in the future
when all the architectures are updated to the new API, hopefully in a
fairly small number of releases, support for the old API will be
withdrawn and only the new API will be available.
