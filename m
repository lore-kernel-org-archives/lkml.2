Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1KWK3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:29:10 -0500
Received: from portal.weinmann.de ([62.8.140.122]:45587 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab1KWK3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:29:09 -0500
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Carsten Behling'" <carsten.behling@garz-fricke.com>
CC: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Nov 2011 11:28:47 +0100
Subject: RE: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Topic: [PATCH v5 3/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Index: AcypMG7f1j3pt+VZTlOvrrSAA2wmYwAAZ+ewACQAp5AAAcQnEA==
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B40D349@wm021.weinmann.com>
References: <D99582E5322435468A77E74BB0039E7B1D1655BF4D@SRV02.hamburg.garz-fricke.de>
 <EF2E73589CA71846A15D0B2CDF79505D087B40D16B@wm021.weinmann.com>
 <D99582E5322435468A77E74BB0039E7B1D1655BFBB@SRV02.hamburg.garz-fricke.de>
In-Reply-To: <D99582E5322435468A77E74BB0039E7B1D1655BFBB@SRV02.hamburg.garz-fricke.de>
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

Carsten Behling wrote on 2011-11-23:

>> this case is already catched in at91_do_twi_transfer():
> 
> Sorry, I did not found this code in your patch.
> (http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg06556.html):
> 
>> +       if (is_read) {
>> +               if (!dev->buf_len)

yes, this won't work for buf_len == 1. It is corrected in
https://lkml.org/lkml/2011/11/18/223 which I held back for some time
as it should have been just a feature extension. I was not aware it
also fixed the buf_len = 1 bug. Sorry for that...

(Explanation: in the first implementation I immediately decremented
buf_len, so buf_len == 1 could not occur. Later I removed that but
did not fully fold it into the base patch.)

Thanks,
Niko

