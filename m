Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab2BVNgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:36:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61435 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2BVNgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:36:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCHv22 14/16] X86: integrate CMA with DMA-mapping subsystem
Date: Wed, 22 Feb 2012 13:36:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <rob.clark@linaro.org>, "Ohad Ben-Cohen" <ohad@wizery.com>
References: <1329507036-24362-1-git-send-email-m.szyprowski@samsung.com> <20120221161802.f6a28085.akpm@linux-foundation.org> <20120222090930.GS22562@n2100.arm.linux.org.uk>
In-Reply-To: <20120222090930.GS22562@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202221336.09808.arnd@arndb.de>
X-Provags-ID: V02:K0:nd/WwvTOYwpwfqOVNYIKP94MQavE/0QA8eKBHeSpONz
 0PyXPXG4/gCUEsjEA1FFWabS0iNoRkUfrbSCBRUOl8rmfP52NC
 cofYoZA2YVubmy1GC3ec/PRVmJsIZd3E/Nc3Wk8jNnMWcS3c/L
 TqHTrnizi7iBK1YZQAUr8XrMsAUvC4awf/uzEjAxfJx1bZ3baH
 /ijFw3x5nqVnDlLS0MmrorYlVmluOTpcUh5ZxWcFhjx/pK8aaJ
 p5jb+dUV8OuVKlOdfQqowwbMD+ID7wXFryeLTJaOeQLBmljNEl
 Cr39JQm+K3hrlxN7r5rT9BZOd2/j7vZEuikT6SzcIRaMJOcafv
 xUy8KRlaQt+URXHzjxBo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 February 2012, Russell King - ARM Linux wrote:
> On Tue, Feb 21, 2012 at 04:18:02PM -0800, Andrew Morton wrote:
> > After a while I got it to compile for i386.  arm didn't go so well,
> > partly because arm allmodconfig is presently horked (something to do
> > with Kconfig not setting PHYS_OFFSET) and partly because arm defconfig
> > doesn't permit CMA to be set.  Got bored, gave up.
> 
> That's not going to get fixed, unfortunately.  It requires us to find
> some way to force various options to certain states on all*config
> builds, because not surprisingly a value of 'y', 'm' or 'n' doesn't
> work for integer or hex config options.
> 
> So the only way all*config can be used on ARM is with a seed config file
> to force various options to particular states to ensure that we end up
> with a sane configuration that avoids crap like that.
> 
> Alternatively, we need a way to tell kconfig that various options are to
> be set in certain ways in the Kconfig files for all*config to avoid it
> wanting values for hex or int options.

I usually set KCONFIG_ALLCONFIG to a file containing the extra options
I want, for another reason: As long as we are building platforms
separately, all{no,yes,mod}config and randconfig will always build
for the versatile platform instead of something more modern.

We could change that and make mach-vexpress the default, but we can
also wait until we have the initial multiplatform support done and
then use that one.

Building vexpress_defconfig (or most other defconfig, I would expect)
works fine with the CMA series applied. This should also work,
but there a few bugs in unrelated device drivers that would need to get
fixed first.

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -sj3 allmodconfig \ 	
	KCONFIG_ALLCONFIG=$PWD/arch/arm/configs/vexpress_defconfig

	Arnd
