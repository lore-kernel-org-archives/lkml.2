Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab1ATXYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:24:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53208 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754715Ab1ATXYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:24:11 -0500
Date: Thu, 20 Jan 2011 23:24:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kim Kyuwon <q1.kim@samsung.com>, Kim Kyuwon <chammoru@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Convert bd2802 driver to dev_pm_ops
Message-ID: <20110120232409.GA23862@opensource.wolfsonmicro.com>
References: <1295559395-28942-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20110120151201.8dca7a7e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120151201.8dca7a7e.akpm@linux-foundation.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 03:12:01PM -0800, Andrew Morton wrote:

> CONFIG_PM=n:

To be honest I've been forming the opinion that this is just cruft these
days - it's hard to see a modern Linux system where you're sufficiently
space constrained to want to turn it off without also being sufficiently
power constrained to want to turn it on and it's hassle to maintain it.
That said...

> It would be nice to fix all this via automagic within the
> SIMPLE_DEV_PM_OPS() implementation but I can't see a way of doing that :(

...the problem here is that the macro is doing roughly the right magic
but the original driver wasn't ifdefing the suspend and resume stuff at
all.  If the were only defining the suspend and resume functions under
CONFIG_PM_SLEEP it should build cleanly.  Since the original driver
didn't have the ifdefs I didn't add or update them.

This means the pm_ops can be unconditionally defined which seems to be
the preferred idiom for this stuff.  If SIMPLE_DEV_PM_OPS() didn't do
the stuff it's doing then the warnings would vanish in the same way they
did originally, by virtue of the functions being unconditionally
referenced from the vtable.
