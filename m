Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2CGNkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:40:07 -0500
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:40177 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755917Ab2CGNkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:40:05 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2012 08:40:04 EST
Date: Wed, 7 Mar 2012 14:22:25 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>, patches@linaro.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Nancy Chen <Nancy.Chen@freescale.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v9] Regulator: Add Anatop regulator driver
Message-ID: <20120307132225.GB17745@game.jcrosoft.org>
References: <1331126658-26926-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331126658-26926-1-git-send-email-paul.liu@linaro.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7172826831719214054
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrvdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrvdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:24 Wed 07 Mar     , Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> Anatop is an integrated regulator inside i.MX6 SoC.
> There are 3 digital regulators which controls PU, CORE (ARM), and SOC.
> And 3 analog regulators which controls 1P1, 2P5, 3P0 (USB).
> This patch adds the Anatop regulator driver.
> 
> Signed-off-by: Nancy Chen <Nancy.Chen@freescale.com>
> Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  .../bindings/regulator/anatop-regulator.txt        |   28 +++
>  drivers/regulator/Kconfig                          |    8 +
>  drivers/regulator/Makefile                         |    1 +
>  drivers/regulator/anatop-regulator.c               |  231 ++++++++++++++++++++
>  4 files changed, 268 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/anatop-regulator.txt
>  create mode 100644 drivers/regulator/anatop-regulator.c
> 
> diff --git a/Documentation/devicetree/bindings/regulator/anatop-regulator.txt b/Documentation/devicetree/bindings/regulator/anatop-regulator.txt
> new file mode 100644
> index 0000000..500463e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/anatop-regulator.txt
> @@ -0,0 +1,28 @@
> +Anatop Voltage regulators
> +
> +Required properties:
> +- compatible: Must be "fsl,anatop-regulator"
> +- vol-bit-shift: Bit shift for the register
> +- vol-bit-width: Number of bits used in the register
> +- min-bit-val: Minimum value of this register
> +- min-voltage: Minimum voltage of this regulator
> +- max-voltage: Maximum voltage of this regulator
specific properites need to be prefix by the vendor

Best Regards,
J.
