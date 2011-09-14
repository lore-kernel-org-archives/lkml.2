Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab1INTTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:19:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47597 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab1INTTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:19:41 -0400
Date: Wed, 14 Sep 2011 20:19:17 +0100
From: Russell King <rmk+alsa@arm.linux.org.uk>
To: Axel Lin <axel.lin@gmail.com>, Harald Welte <laforge@openezx.org>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [linux-next] ASoC: sound/soc/samsung/neo1973_wm8753.c build
	failure
Message-ID: <20110914191917.GA30518@flint.arm.linux.org.uk>
References: <1315991893.17271.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315991893.17271.2.camel@phoenix>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 05:18:13PM +0800, Axel Lin wrote:
> Hi,
> 
> I got below build error: ( on linux-next 20110831 )
>   CC      sound/soc/samsung/neo1973_wm8753.o
> sound/soc/samsung/neo1973_wm8753.c: In function 'neo1973_wm8753_init':
> sound/soc/samsung/neo1973_wm8753.c:325: error: implicit declaration of function 'machine_is_neo1973_gta01'
> make[3]: *** [sound/soc/samsung/neo1973_wm8753.o] Error 1
> make[2]: *** [sound/soc/samsung] Error 2
> make[1]: *** [sound/soc] Error 2
> make: *** [sound] Error 2
> 
> I think the root cause is below commit:
> commit 6f82f4db "ARM: Update (and cut down) mach-types"
> removes neo1973_gta01 entry.
> 
> I'm not sure if we should add back the neo1973_gta01 entry to mach-types or
> remove all machine_is_neo1973_gta01() calls in neo1973_wm8753.c.
> Comments?

neo1973_gta01 was added to the database in October 2006.  Five months
later, neo1973_gta02 was registered by the same person (Harald Welte),
and gta02 has been merged.

Therefore, I suggest that the GTA01 will never be submitted now, moreover
I suggest that neo1973_gta01 was probably a prototype and neo1973_gta02
was probably the production platform.

So I suggest these references should be removed.  If the platform is not
going to be merged its pointless carrying the baggage around in drivers.
Maybe Harald can confirm?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
