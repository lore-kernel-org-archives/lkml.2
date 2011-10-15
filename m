Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1JOOZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 10:25:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51987 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab1JOOZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 10:25:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv16 0/9] Contiguous Memory Allocator
Date: Sat, 15 Oct 2011 16:24:45 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Paul McKenney <paul.mckenney@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <jweiner@redhat.com>
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com> <201110111552.04615.arnd@arndb.de> <20111014161951.5b4bb327.akpm@linux-foundation.org>
In-Reply-To: <20111014161951.5b4bb327.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110151624.47336.arnd@arndb.de>
X-Provags-ID: V02:K0:BRlEgVGy2kc8XWoJIs6uDH3aX6CzMcRwn2abk+QCcmM
 rRtfLGS8X98vOYbGxDKfS/Fsb9waueT55DLhvK0Wra+jfF+H0w
 eG4o9LjrlPPSzFpYRffIYkIyRhW4BimmCw20mumGKol/fk98rF
 VEUPFm7mev8gZwiSY7yudl2/rPaI2SLRrc6adrx6XYqcNCGX7a
 YAz+XO69yZ8U6rbpi7724QtPYewCpaiNU2qg+VBr+iNxyTMMKB
 BIdh/KcApaKNACOQIhgEv0n/3wflak5ZMqmy/P1qK1eVkFuuTh
 GHeoO5869vSdOfKonLxID0YJbYcagplALKv2h/FlxLbOosv1Ob
 B3YDA9eGa9nBCMzkrDWA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 October 2011, Andrew Morton wrote:
> 
> On Tue, 11 Oct 2011 15:52:04 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> > What I would really want to hear from you is your opinion on
> > the architecture independent stuff. Obviously, ARM is the
> > most important consumer of the patch set, but I think the
> > code has its merit on other architectures as well and most of
> > them (maybe not parisc) should be about as simple as the x86
> > one that Marek posted now with v16.
> 
> Having an x86 implementation is good.  It would also be good to get
> some x86 drivers using CMA asap, so the thing gets some runtime testing
> from the masses.  Can we think of anything we can do here?

With the current implementation, all drivers that use dma_alloc_coherent
automatically use CMA, there is no need to modify any driver. On
the other hand, nothing on x86 currently actually requires this feature
(otherwise it would be broken already), making it hard to test the
actual migration path.

The best test I can think of would be a network benchmark under memory
pressure, preferrably one that use large jumbo frames (64KB).

	Arnd
