Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076Ab2D0Jy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 05:54:29 -0400
Received: from mailout.artfiles.de ([80.252.97.80]:49649 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760054Ab2D0Jy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 05:54:28 -0400
X-Greylist: delayed 4648 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2012 05:54:27 EDT
From: Carsten Behling <carsten.behling@garz-fricke.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
CC: Marc-Oliver Westerburg <Westerburg@garz-fricke.com>,
        "'devel@ayanes.com'" <devel@ayanes.com>,
        "'Wolfram Sang'" <w.sang@pengutronix.de>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'Hubert Feurstein'" <h.feurstein@gmail.com>
Date: Fri, 27 Apr 2012 10:36:47 +0200
Subject: AW: [PATCH v10 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Topic: [PATCH v10 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Index: Ac0jm+pMKMPpyAg9SvaWiRkamqQ1mgApH2jwAADejhAAAzS8cA==
Message-ID: <D99582E5322435468A77E74BB0039E7B1D2293684D@SRV02.hamburg.garz-fricke.de>
References: <D99582E5322435468A77E74BB0039E7B1D22784CF0@SRV02.hamburg.garz-fricke.de>
 <alpine.DEB.2.00.1204261035060.16439@gatekeeper.vosshq.de>
 <D99582E5322435468A77E74BB0039E7B1D22784E8B@SRV02.hamburg.garz-fricke.de>
 <EF2E73589CA71846A15D0B2CDF79505D0905E0994A@wm021.weinmann.com>
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D0905E0994A@wm021.weinmann.com>
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

Hi Niko,

you a right. Driver works with that patch.

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
Gesendet: Freitag, 27. April 2012 10:05
An: Carsten Behling
Cc: Marc-Oliver Westerburg; 'devel@ayanes.com'; 'Wolfram Sang'; 'linux-arm-kernel@lists.infradead.org'; 'linux-kernel@vger.kernel.org'; 'linux-i2c@vger.kernel.org'; 'Hubert Feurstein'
Betreff: RE: [PATCH v10 3/4] drivers/i2c/busses/i2c-at91.c: add new driver

Hi Carsten,

Carsten Behling wrote on 2012-04-27:
>>  	INIT_COMPLETION(dev->cmd_complete);
>> +	dev->transfer_status = 0;
>>  	if (dev->msg->flags & I2C_M_RD) {
>>  		unsigned start_flags = AT91_TWI_START;
> 
> this patch will not work, because you reset 'dev->transfer_status'
> before it is evaluated on errors (AT91_TWI_NACK, AT91_TWI_OVRE). 

it should, because transfer_status is updated by the ISR between
wait_for_completion_interruptible_timeout() and the error evaluation.
Please try it out.

> > P.S. Are you using a RM9200? Seems that this SOC has some problems...
> 
> Yes, our ECO920 uses the RM9200, but we support it with an very old kernel
> (2.6.21). I remember there were many problems with I2C.

Ok, but good to hear the driver basically works with the RM9200.

Niko

