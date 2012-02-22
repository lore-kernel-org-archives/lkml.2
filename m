Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2BVJKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:10:00 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51513 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab2BVJJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:09:57 -0500
Date: Wed, 22 Feb 2012 09:09:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <rob.clark@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCHv22 14/16] X86: integrate CMA with DMA-mapping subsystem
Message-ID: <20120222090930.GS22562@n2100.arm.linux.org.uk>
References: <1329507036-24362-1-git-send-email-m.szyprowski@samsung.com> <1329507036-24362-15-git-send-email-m.szyprowski@samsung.com> <20120221161802.f6a28085.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221161802.f6a28085.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 04:18:02PM -0800, Andrew Morton wrote:
> After a while I got it to compile for i386.  arm didn't go so well,
> partly because arm allmodconfig is presently horked (something to do
> with Kconfig not setting PHYS_OFFSET) and partly because arm defconfig
> doesn't permit CMA to be set.  Got bored, gave up.

That's not going to get fixed, unfortunately.  It requires us to find
some way to force various options to certain states on all*config
builds, because not surprisingly a value of 'y', 'm' or 'n' doesn't
work for integer or hex config options.

So the only way all*config can be used on ARM is with a seed config file
to force various options to particular states to ensure that we end up
with a sane configuration that avoids crap like that.

Alternatively, we need a way to tell kconfig that various options are to
be set in certain ways in the Kconfig files for all*config to avoid it
wanting values for hex or int options.
