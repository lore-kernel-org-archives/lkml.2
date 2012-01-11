Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab2AKOXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 09:23:52 -0500
Received: from portal.weinmann.de ([62.8.140.122]:57595 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932777Ab2AKOXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 09:23:50 -0500
X-Greylist: delayed 990 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jan 2012 09:23:50 EST
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Carsten Behling'" <carsten.behling@garz-fricke.com>,
        "'Hubert Feurstein'" <h.feurstein@gmail.com>
CC: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>
Date: Wed, 11 Jan 2012 15:06:52 +0100
Subject: RE: [PATCH v7 0/5] AT91: replace broken TWI driver i2c-at91.c
Thread-Topic: [PATCH v7 0/5] AT91: replace broken TWI driver i2c-at91.c
Thread-Index: AcyriE4lmXusT3tqSuS+KTzpHfrqPAZ3V8ygAsCEIJA=
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D0882DEF3E8@wm021.weinmann.com>
References: <cover.1322062555.git.n.voss@weinmann.de>
 <4ECFB755.6060509@gmail.com>
 <D99582E5322435468A77E74BB0039E7B1D18739F99@SRV02.hamburg.garz-fricke.de>
In-Reply-To: <D99582E5322435468A77E74BB0039E7B1D18739F99@SRV02.hamburg.garz-fricke.de>
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

Carsten Behling wrote on 2011-12-28:
> I've tested this driver with the pca953x GPIO expander driver with a PCA9554.
> 
> In the case of 8 GPIO pins (my case) "i2c_smbus_read_byte_data(...)"
[...]
> I observed that reading out the GPIO status is one read delayed.
> The first read to a register from the pca953x driver does not result in a
> RXRDY interrupt and at91_twi_read_next_byte(...) is not called.
> Only the completion routine is triggered with a TXCOMP interrupt.

Which SOC are you using? This is probably a hardware bug since on my
at91sam9g45 i2c_smbus_read_byte_data() works reliably without any
problems. Please check the errata and see if there is a useable
workaround. If not, the driver should be disabled for your SOC.

> Additionally, I took a look at the status flags just after the control flags
> are set (in at91_do_twi_transfer(...), AT91_TWI_START|AT91_TWI_STOP for the
> one byte read). Surprisingly, the AT91_TWI_RXRDY flag is zero before the first
> register read and one for the following reads. According to the manual this
> flag should be zero after a read on AT91_TWI_RHR.
> 
> Reading the AT91_TWI_RHR before the control flags are set to be sure that the
> AT91_TWI_RXRDY is cleared leads to a never occurring RXRDY interrupt.

Again, this behavior does not conform to the datasheet, I suspect documented
or undocumented errata... At91rm9200 has at least one erratum for which I
imported a workaround from the old driver (which does not use interrupts).

Niko

