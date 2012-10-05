Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab2JETE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:04:29 -0400
Received: from mo5.mail-out.ovh.net ([178.32.228.5]:35366 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2JETE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:04:28 -0400
Date: Fri, 5 Oct 2012 20:56:43 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        arnd@arndb.de
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 04/10] of/i2c: Add support for I2C_CLIENT_WAKE when
 booting with Device Tree
Message-ID: <20121005185643.GC12462@game.jcrosoft.org>
References: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
 <1349451107-8009-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349451107-8009-5-git-send-email-lee.jones@linaro.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 3312679002474130431
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrtdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehuddrtdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:31 Fri 05 Oct     , Lee Jones wrote:
> It's important for wakeup sources such as keyboards, power buttons
> and the like to identify themselves as wakeup devices. Until now
> this has not been possible when platforms are booting via Device
> Tree.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/of/of_i2c.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
> index 1e173f3..2f20019 100644
> --- a/drivers/of/of_i2c.c
> +++ b/drivers/of/of_i2c.c
> @@ -61,6 +61,9 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
>  		info.of_node = of_node_get(node);
>  		info.archdata = &dev_ad;
>  
> +		if (of_get_property(node, "i2c-client-wake", NULL))
> +			info.flags |= I2C_CLIENT_WAKE;
use of_property_read_bool

Best Regards,
J.
