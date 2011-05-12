Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab1ELVRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:17:36 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:60580 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730Ab1ELVRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:17:35 -0400
From: Matthieu Castet <matthieu.castet@parrot.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 12 May 2011 22:17:02 +0100
Subject: RE : [PATCH 0/4] Pinmux subsystem
Thread-Topic: [PATCH 0/4] Pinmux subsystem
Thread-Index: AcwQrVUzIyqH5uUbQTC8S4FEDfYPTwAOCx/Q
Message-ID: <F5C24FC168F95048BB6B9E0B13EB33152BA6F5307A@DIAMANT.xi-lite.lan>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
	<20110512074421.GA2429@pengutronix.de>,<BANLkTi=N8VNh3tPxYH8dQ0UtGpN=xSzKng@mail.gmail.com>
In-Reply-To: <BANLkTi=N8VNh3tPxYH8dQ0UtGpN=xSzKng@mail.gmail.com>
Accept-Language: fr-FR
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: fr-FR
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+In this 8x8 BGA package the pins { A8, A7, A6, A5 } can be used as an SPI port
+(these are four pins: CLK, RXD, TXD, FRM). In that case, pin B5 can be used as
+some general-purpose GPIO pin. However, in another setting, pins { A5, B5 } can
+be used as an I2C port (these are just two pins: SCL, SDA). Needless to say,
+we cannot use the SPI port and I2C port at the same time. However in the inside
+of the package the silicon performing the SPI logic can alternatively be routed
+out on pins { G4, G3, G2, G1 }.

Enumerating all possible case will be impossible because of the number of possible cases 
(and hardware guys can be very creative).

If spi can be in  { A8, A7, A6, A5 } and 
{ G4, G3, G2, G1 }, Then you can output the spi on :
- { A8, A7, A6, A5 }
- { A8, A7, A6, G1 }
- { A8, A7, G2, A5 }
[...]
- { G4, G3, G2, A5 }
- { G4, G3, G2, G1 }
You have 2^4 = 16 cases

Now RXD (MISO) or/and FRM (CS) can be not connected and used as a gpio. You have 4 * 16 cases = 64 cases.

Now take a complex chip, 200 balls 4 mux per ball and you can have up to 4^200 configurations...

Pin muxing is really board specific  and shouldn't be in a "generic" driver.

But what you could abstract is a way to select a configuration of a pin, not a group of pin
 for the board files.

Matthieu