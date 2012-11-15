Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892Ab2KOK4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:56:51 -0500
Received: from 16.mo5.mail-out.ovh.net ([87.98.174.144]:54433 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964838Ab2KOK4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:56:49 -0500
X-Greylist: delayed 3274 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2012 05:56:49 EST
Date: Thu, 15 Nov 2012 11:15:08 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, jonas.aberg@stericsson.com,
        linux@arm.linux.org.uk, linus.walleij@stericsson.com, arnd@arndb.de
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 0/2] Boottime: measure bootloader and kernel bootup time
Message-ID: <20121115101508.GB4398@game.jcrosoft.org>
References: <1352973847-21605-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352973847-21605-1-git-send-email-lee.jones@linaro.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13919219074494213119
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehgedrtdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehgedrtdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:04 Thu 15 Nov     , Lee Jones wrote:
> This patchset supplies a new tool which measures boottime inclusive
> of bootloader involvement. It seems to be accurate and adds no
> latency to the booting of the system.
> 
> In the first round of testing we booted the kernel 3 times each with
> boottime enabled and disabled. Actually, when it was disabled, the
> code was completely removed from the kernel source and the kernel was
> rebuilt. The difference between present & enabled and completely
> removed was very little indeed. In fact, averaging out the 3 runs of
> each, when boottime was enabled the system booted 4ms _faster_, go
> figure!
> 
>              Enabled    Disabled
>   1st run    2.983093   2.985168
>   2nd run    2.973266   2.971801
>   3rd run    2.975402   2.987304
>   Average    2.977254   2.981424   -0.004171 (-4ms)
> 
> 
> For the next round of testing, we delayed the bootloader for varying
> amounts of time, then started to remove key components from kernel
> functionality to see if the boottime system would pick-up on them.
> 
>   /* Hang around in the bootloader for a while. */
>   $ cat /sys/kernel/debug/boottime/summary 
>     kernel: 42864 msecs
>     total: 42864 msecs
>     kernel: cpu0 system: 56% idle: 43% iowait: 0% irq: 0% 
>             cpu1 system: 4% idle: 95% iowait: 0% irq: 0%
> 
>   /* Hang around in the bootloader for a smaller amount of time. */
>     kernel: 12351 msecs
>     total: 12351 msecs
>     kernel: cpu0 system: 56% idle: 43% iowait: 0% irq: 0% 
>             cpu1 system: 2% idle: 97% iowait: 0% irq: 0%
>   
>   /* Instant boot. (1st run) */
>     kernel: 7833 msecs
>     total: 7833 msecs
>     kernel: cpu0 system: 55% idle: 44% iowait: 0% irq: 0% 
>             cpu1 system: 3% idle: 96% iowait: 0% irq: 0%
> 
>   /* Instant boot. (2nd run) */
>     kernel: 7817 msecs
>     total: 7817 msecs
>     kernel: cpu0 system: 53% idle: 46% iowait: 0% irq: 0% 
>             cpu1 system: 8% idle: 91% iowait: 0% irq: 0%
> 
>   /* Instant boot. (3rd run) */
>     kernel: 7747 msecs
>     total: 7747 msecs
>     kernel: cpu0 system: 56% idle: 42% iowait: 0% irq: 0% 
>             cpu1 system: 2% idle: 97% iowait: 0% irq: 0%
7/8s? on a u9500 wow it's really slow

I do 2/3s here

Best Regards.
J.
