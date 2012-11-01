Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935568Ab2KAOtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:49:42 -0400
Received: from 3.mo4.mail-out.ovh.net ([46.105.57.129]:52005 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754175Ab2KAOt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:49:26 -0400
Date: Thu, 1 Nov 2012 15:47:07 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, havard@skinnemoen.net,
        bhutchings@solarflare.com, linux-arm-kernel@lists.infradead.org,
        patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
        manabian@gmail.com, David.Laight@ACULAB.COM
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v4 00/10] net/macb: driver enhancement concerning GEM
 support, ring logic and cleanup
Message-ID: <20121101144707.GH19021@game.jcrosoft.org>
References: <cover.1351690694.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1351690694.git.nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 10057945343622228844
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehfedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:04 Wed 31 Oct     , Nicolas Ferre wrote:
> This is an enhancement work that began several years ago. I try to catchup with
> some performance improvement that has been implemented then by Havard.
> The ring index logic and the TX error path modification are the biggest changes
> but some cleanup/debugging have been added along the way.
> The GEM revision will benefit from the Gigabit support.
> Newer pinctrl infrastructure support is added but it is optional.
> 
> The series has been tested on several Atmel AT91 SoC with the two MACB/GEM
> flavors.
> 
> v4: - remove unneeded device tree header includes
>     - modified the computation of available entries in ring buffer
> v3: - rebased on net-next to take into account current effor to merge
>       at91_ether with macb drivers
>     - add additional patch to use the new pinctrl infrastructure
> v2: - modify the tx error handling: now uses a workqueue
>     - information provided by ethtool -i were not accurate: removed
> 
> 
> Havard Skinnemoen (4):
>   net/macb: memory barriers cleanup
>   net/macb: change debugging messages
>   net/macb: clean up ring buffer logic
>   net/macb: Offset first RX buffer by two bytes
> 
> Jean-Christophe PLAGNIOL-VILLARD (1):
>   net/macb: add pinctrl consumer support
> 
> Nicolas Ferre (4):
>   net/macb: remove macb_get_drvinfo()
>   net/macb: tx status is more than 8 bits now
>   net/macb: ethtool interface: add register dump feature
>   net/macb: better manage tx errors
> 
> Patrice Vilchez (1):
>   net/macb: Add support for Gigabit Ethernet mode
> 
>  drivers/net/ethernet/cadence/at91_ether.c |   6 +-
>  drivers/net/ethernet/cadence/macb.c       | 448 +++++++++++++++++++++---------
>  drivers/net/ethernet/cadence/macb.h       |  30 +-
>  3 files changed, 337 insertions(+), 147 deletions(-)
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
> 
> -- 
> 1.8.0
> 
