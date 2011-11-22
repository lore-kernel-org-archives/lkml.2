Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab1KVQ0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:26:37 -0500
Received: from portal.weinmann.de ([62.8.140.122]:14104 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758046Ab1KVQ0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:26:35 -0500
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Carsten Behling'" <carsten.behling@garz-fricke.com>
CC: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Nov 2011 17:26:18 +0100
Subject: RE: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Topic: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Index: AcypMG7f1j3pt+VZTlOvrrSAA2wmYwAAZ+ew
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B40D16B@wm021.weinmann.com>
References: <D99582E5322435468A77E74BB0039E7B1D1655BF4D@SRV02.hamburg.garz-fricke.de>
In-Reply-To: <D99582E5322435468A77E74BB0039E7B1D1655BF4D@SRV02.hamburg.garz-fricke.de>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Carsten Behling wrote on 2011-11-22:
> +static void at91_twi_read_next_byte(struct at91_twi_dev *dev)
> +{
> +       *dev->buf = at91_twi_read(dev, AT91_TWI_RHR) & 0xff;
> +
> +       /* send stop if second but last byte has been read */
> +       if (--dev->buf_len == 1)
> +               at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_STOP);
> 
> 
> 
> If dev->buf_len =1 at the beginning of a read transfer, a stop condition will
> never be send.

this case is already catched in at91_do_twi_transfer():

+       if (dev->msg->flags & I2C_M_RD) {
+               unsigned start_flags = AT91_TWI_START;
+
+               /* if only one byte is to be read, immediately stop transfer */
+               if (dev->buf_len <= 1 && !(dev->msg->flags & I2C_M_RECV_LEN))
+                       start_flags |= AT91_TWI_STOP;
+               at91_twi_write(dev, AT91_TWI_CR, start_flags);

Thanks for reviewing,
Niko

