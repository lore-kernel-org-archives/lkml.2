Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab1FPOU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 10:20:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106Ab1FPOUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 10:20:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC PATCH 11/11] arm/versatile: Add device tree support
Date: Thu, 16 Jun 2011 16:20:37 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20110616042653.29371.2052.stgit@ponder> <20110616044311.29371.49018.stgit@ponder>
In-Reply-To: <20110616044311.29371.49018.stgit@ponder>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161620.37205.arnd@arndb.de>
X-Provags-ID: V02:K0:n3F/zXr96s3nYH1L4rp1dpQJO3d6gv7pcoE+APescKE
 54Y/TcDS3ITVv1AwQ0t4cl5GVFo3LrFNfAiAn+CTT/Z6mnEx1V
 tHD8TqLXS3AEpdyu09dZiD/BA9KUw4SheTa3MMLMB18spvtYim
 sfLfDZCjVNijnm5fhzJh6Br8H9MuMhj9FAB9wrABm89fECVrOe
 yrEknykrVaqbcfeqnqwFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 June 2011, Grant Likely wrote:
> This patch adds a new versatile platform for when using the device
> tree.  Add platform and amba devices are discovered and registered by
> parsing the device tree.  Clocks and initial io mappings are still
> configured statically.

Hi Grant,

Two small questions about the device tree contents:

> +       i2c@10002000 {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               compatible = "arm,versatile-i2c";
> +               reg = <0x10002000 0x1000>;
> +
> +               rtc@68 {
> +                       compatible = "dallas,ds1338";
> +                       reg = <0x68>;
> +               };
> +       };
> +
> +       net@10010000 {
> +               compatible = "smsc,lan91c111";
> +               reg = <0x10010000 0x10000>;
> +               interrupts = <25>;
> +       };
> +
> +       lcd@10008000 {
> +               compatible = "arm,versatile-lcd";
> +               reg = <0x10008000 0x1000>;
> +       };

Why are these devices on the top level, rather than on the AMBA bus or
the FPGA? From the documentation, it seems that they are implemented
in the FPGA, which would also match the address layout.

> +       amba {
> +               compatible = "arm,amba-bus";
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               ranges;
> +
> +               vic: intc@10140000 {
> +                       compatible = "arm,versatile-vic", "arm,vic";
> +                       interrupt-controller;
> +                       #interrupt-cells = <1>;
> +                       reg = <0x10140000 0x1000>;
> +               };
> +

Why the empty ranges property? All device registers are based on 0x10000000,
so I'd expect this to be described like that here.

	Arnd
