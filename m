Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196Ab1JDTYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:24:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58874 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab1JDTYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:24:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 07/24] C6X: devicetree support
Date: Tue, 04 Oct 2011 21:24:32 +0200
Message-ID: <33796617.9qot9H6oBs@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1317746641-26725-8-git-send-email-msalter@redhat.com>
References: <1317746641-26725-1-git-send-email-msalter@redhat.com> <1317746641-26725-8-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:weZ1XFjGXyZHYr6cMRKk7Tu+ufFYh/AGlp9tq/aCcs9
 na8/8NLd4KWm9t3D/b/KssFlDoyz1NEodOoc6hb9DyMXqjBqVR
 lyVc02i/UruCWQCmt+oOmdIquV6hcl0qRzcj/PTnKaf3Sb+XoS
 7aN1uDiVnQ6g/NQvRtIQET25pfbnSp/IfdGpoldiga0ZhHcKyE
 zsf1r5ipAFIwhzv8R8z6lUsu7Hq9Ms/+h0WoSzAohtiV8prRhq
 oeku01LIXtNVGbxrMpZMO+FoBwEuyFv5AKHAR0DeUHvISybfG2
 SkyR8Kmt4BOX+uJ2J3QNNj5ZaVH6xNcJW9zWox3+PQMX1eqP0C
 NfQI+HLkw225phmmj3bs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 October 2011 12:43:44 Mark Salter wrote:
> This is the basic devicetree support for C6X. Currently, four boards are
> supported. Each one uses a different SoC part. Two of the four supported
> SoCs are multicore. One with 3 cores and the other with 6 cores. There is
> no coherency between the core-level caches, so SMP is not an option. It is
> possible to run separate kernel instances on the various cores. There is
> currently no C6X bootloader support for device trees so we build in the DTB
> for now.
> 
> There are some interesting twists to the hardware which are of note for device
> tree support. Each core has its own interrupt controller which is controlled
> by special purpose core registers. This core controller provides 12 general
> purpose prioritized interrupt sources. Each core is contained within a
> hardware "module" which provides L1 and L2 caches, power control, and another
> interrupt controller which cascades into the core interrupt controller. These
> core module functions are controlled by memory mapped registers. The addresses
> for these registers are the same for each core. That is, when coreN accesses
> a module-level MMIO register at a given address, it accesses the register for
> coreN even though other cores would use the same address to access the register
> in the module containing those cores. Other hardware modules (timers, enet, etc)
> which are memory mapped can be accessed by all cores.
> 
> The timers need some further explanation for multicore SoCs. Even though all
> timer control registers are visible to all cores, interrupt routing or other
> considerations may make a given timer more suitable for use by a core than
> some other timer. Because of this and the desire to have the same image run
> on more than one core, the timer nodes have a "ti,core-mask" property which
> is used by the driver to scan for a suitable timer to use.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> Signed-off-by: Aurelien Jacquiot <a-jacquiot@ti.com>
> CC: devicetree-discuss@lists.ozlabs.org
> CC: Grant Likely <grant.likely@secretlab.ca>
> CC: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>
