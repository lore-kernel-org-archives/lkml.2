Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab1IOKlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:41:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57929 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932606Ab1IOKlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:41:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 3/5] of/irq: introduce of_irq_init
Date: Thu, 15 Sep 2011 12:41:32 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        marc.zyngier@arm.com, thomas.abraham@linaro.org, jamie@jamieiles.com,
        b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-4-git-send-email-robherring2@gmail.com>
In-Reply-To: <1316017900-19918-4-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109151241.32951.arnd@arndb.de>
X-Provags-ID: V02:K0:rIrMwXHZ4in8UTb7jT6IU+o1ebLB1oKTdzvVxGD5mH5
 /sXD4Gv/8OTLuE5BN1q57EVnTFQIHtnEw3qrTN87WdzY5yOoWt
 7qbQksCM0CvIwek0wOLo8Hu1YXRNwESbQbtPF6Gl5N2ln3+ATX
 H1uLabMolqR8TlXyzSuJZzecEPhT6QpbGytf+VwrpFM3NDNjuX
 FtPiWoriQ1xur+8kekR8y4XasKiF4hR39XkUnGS8FlLF2Wq4F/
 LoOFYrguYTTKC+8fuDmFSEgypgnuET3lWseMbiS5Yzq5qlx28J
 celWzpH5S88DCYqYNE7kDhWe9oBRd2a4DRMCmgwK4saSiYum7b
 1e5AoUfMhkmLhgHFn23s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 September 2011, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> of_irq_init will scan the devicetree for matching interrupt controller
> nodes. Then it calls an initialization function for each found controller
> in the proper order with parent nodes initialized before child nodes.
> 
> Based on initial pseudo code from Grant Likely.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Looks good to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>

> +
> +struct intc_desc {
> +       struct list_head        list;
> +       struct device_node      *dev;
> +       struct device_node      *parent;
> +};

One tiny comment: how about naming the parent 'interrupt_parent'? While
reading through the code, I was confused for a short time until I figured
out what this is about.

	Arnd
