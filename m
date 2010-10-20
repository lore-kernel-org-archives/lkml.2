Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0JTRFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 13:05:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41067 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab0JTRFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 13:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=XhRZtk88NyFK4dgg4Vmb6/zBKJJPhx2Il8i3jGE42t2PRPCidd8YZMicITV5HTwhkb
         Vw7poeKgA3A39s1qaxDLDbTlx7kk7Vx1av50tGA7pS3p3vGPh2CWdErRqrKlZdNok4Pu
         /OhABlYPVDQIhxQJ9ZTiPqcQmuDjqr5s50Yvs=
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>,
        Juhos Gabor <juhosg@openwrt.org>
Subject: Re: [PATCH v5] GPIO: add support for 74x164 serial-in/parallel-out 8-bit shift register
Date: Wed, 20 Oct 2010 19:06:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-server; KDE/4.5.1; x86_64; ; )
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>
References: <201010182135.09506.florian@openwrt.org> <AANLkTi=zj0Bns6eo40ksr52YKScarVvhMPNpxdT=Fjp7@mail.gmail.com>
In-Reply-To: <AANLkTi=zj0Bns6eo40ksr52YKScarVvhMPNpxdT=Fjp7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010201906.41047.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 October 2010 14:51:42 Bastien ROUCARIES wrote:
> On Mon, Oct 18, 2010 at 9:35 PM, Florian Fainelli <florian@openwrt.org> 
wrote:
> > From: Miguel Gaio <miguel.gaio@efixo.com>
> > 
> > This patch adds support for generic 74x164 serial-in/parallel-out 8-bits
> > shift register. This driver can be used as a GPIO output expander.
> 
> Could you add some documentation ? how to wire it both in soft and hard
> part?

This is just an example of course, and I will add a subsequent patch adding an 
entry for it in Documentation/

static struct spi_board_info board_spi_devices[] = {
 {
	.modalias = "74x164",
	.max_speed_hz = 781000,
	.bus_num = 1,
	.controller_data = (void *) SPI_GPIO_NO_CHIPSELECT,
	.mode = SPI_MODE_0,
	.platform_data = &nb4_74x164_platform_data
}
};

and then registering your board_spi_devices with:

spi_register_board_info(board_spi_devices, ARRAY_SIZE(board_spi_devices);
--
Florian
