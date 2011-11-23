Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab1KWKgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:36:53 -0500
Received: from mailout.artfiles.de ([80.252.97.80]:37436 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1KWKgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:36:51 -0500
X-Greylist: delayed 3903 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Nov 2011 05:36:51 EST
From: Carsten Behling <carsten.behling@garz-fricke.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
CC: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Nov 2011 10:31:44 +0100
Subject: AW: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Topic: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Index: AcypMG7f1j3pt+VZTlOvrrSAA2wmYwAAZ+ewACQAp5A=
Message-ID: <D99582E5322435468A77E74BB0039E7B1D1655BFBB@SRV02.hamburg.garz-fricke.de>
References: <D99582E5322435468A77E74BB0039E7B1D1655BF4D@SRV02.hamburg.garz-fricke.de>
 <EF2E73589CA71846A15D0B2CDF79505D087B40D16B@wm021.weinmann.com>
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B40D16B@wm021.weinmann.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this case is already catched in at91_do_twi_transfer():

Sorry, I did not found this code in your patch.
(http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg06556.html):

> +       if (is_read) {
> +               if (!dev->buf_len)
> +                       at91_twi_write(dev, AT91_TWI_CR,
> +                                      AT91_TWI_START | AT91_TWI_STOP);
> +               else
> +                       at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_START);
> +               at91_twi_write(dev, AT91_TWI_IER,
> +                              AT91_TWI_TXCOMP | AT91_TWI_RXRDY);
> +       } else {
> +               at91_twi_write_next_byte(dev);
> +               at91_twi_write(dev, AT91_TWI_IER,
> +                              AT91_TWI_TXCOMP | AT91_TWI_TXRDY);
> +       }

Is there a more recent version ?

Mit freundlichen Grüßen / Best regards
Carsten Behling

Development Engineer
Garz & Fricke GmbH
Tempowerkring 2, 21079 Hamburg - Germany
Amtsgericht Hamburg HRB 60514
Geschäftsführer: Manfred Garz, Matthias Fricke
Phone: +49 (0) 40 791 899 - 56
Fax:    +49 40 / 791 899 - 39
www.garz-fricke.com 

 


-----Ursprüngliche Nachricht-----
Von: Voss, Nikolaus [mailto:N.Voss@weinmann.de] 
Gesendet: Dienstag, 22. November 2011 17:26
An: Carsten Behling
Cc: 'linux-i2c@vger.kernel.org'; 'linux-arm-kernel@lists.infradead.org'; 'linux-kernel@vger.kernel.org'
Betreff: RE: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver

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

