Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2JBTRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 15:17:19 -0400
Received: from 3.mo3.mail-out.ovh.net ([46.105.44.175]:33722 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751204Ab2JBTRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 15:17:17 -0400
X-Greylist: delayed 1150 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2012 15:17:17 EDT
Date: Tue, 2 Oct 2012 20:56:51 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH 07/17] ARM: at91: skip at91_io_desc definition for NOMMU
Message-ID: <20121002185651.GC5117@game.jcrosoft.org>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
 <1349195816-2225-8-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349195816-2225-8-git-send-email-arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 4144156082652293892
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:36 Tue 02 Oct     , Arnd Bergmann wrote:
> On NOMMU systems, we do cannot remap the MMIO space, so the
> definition of at91_io_desc is unused.
> 
> Without this patch, building at91x40_defconfig results in:
> 
> arch/arm/mach-at91/setup.c:90:24: warning: 'at91_io_desc' defined but not used [-Wunused-variable]
I prefer a __maybe_unused on the struct so the compilator will just drop it

Best Regards,
J.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> ---
>  arch/arm/mach-at91/setup.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index 944bffb..b9fdba0 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -87,12 +87,14 @@ void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
>  	iotable_init(desc, 1);
>  }
>  
> +#ifdef CONFIG_MMU
>  static struct map_desc at91_io_desc __initdata = {
>  	.virtual	= AT91_VA_BASE_SYS,
>  	.pfn		= __phys_to_pfn(AT91_BASE_SYS),
>  	.length		= SZ_16K,
>  	.type		= MT_DEVICE,
>  };
> +#endif
>  
>  static void __init soc_detect(u32 dbgu_base)
>  {
> -- 
> 1.7.10
> 
