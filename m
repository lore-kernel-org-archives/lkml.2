Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2ILMDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:03:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52767 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756296Ab2ILMDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:03:03 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "S, Venkatraman" <svenkatr@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "cjb@laptop.org" <cjb@laptop.org>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>
Subject: RE: [PATCH] mmc: omap_hsmmc: Enable HSPE bit for high speed cards
Thread-Topic: [PATCH] mmc: omap_hsmmc: Enable HSPE bit for high speed cards
Thread-Index: AQHNiqD9Is2lA8IYP0Sv6fHcSAOj0JeGFa+AgACMIOA=
Date: Wed, 12 Sep 2012 12:02:54 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EA804A8@DBDE01.ent.ti.com>
References: <1346764151-21323-1-git-send-email-gururaja.hebbar@ti.com>
 <CANfBPZ-Wb7HE45DTmwsMt-hpJRUevjbjm9-aCR61B4JFULb8Mw@mail.gmail.com>
In-Reply-To: <CANfBPZ-Wb7HE45DTmwsMt-hpJRUevjbjm9-aCR61B4JFULb8Mw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {20A2B275-26C5-4D43-B732-A9DDCC74933C}
x-cr-hashedpuzzle: CZ5N F733 OTZO S0et Y9Sc bCgo ctQk hOmf jI1O mKmQ rjUn
 s1Fb w1Fu 3By4 9A5s
 9THs;6;YwBqAGIAQABsAGEAcAB0AG8AcAAuAG8AcgBnADsAZwByAGEAbgB0AC4AbABpAGsAZQBsAHkAQABzAGUAYwByAGUAdABsAGEAYgAuAGMAYQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBtAG0AYwBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AbwBtAGEAcABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgBvAGIALgBoAGUAcgByAGkAbgBnAEAAYwBhAGwAeABlAGQAYQAuAGMAbwBtAA==;Sosha1_v1;7;{20A2B275-26C5-4D43-B732-A9DDCC74933C};ZwB1AHIAdQByAGEAagBhAC4AaABlAGIAYgBhAHIAQAB0AGkALgBjAG8AbQA=;Wed,
 12 Sep 2012 12:02:37
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAbQBtAGMAOgAgAG8AbQBhAHAAXwBoAHMAbQBtAGMAOgAgAEUAbgBhAGIAbABlACAASABTAFAARQAgAGIAaQB0ACAAZgBvAHIAIABoAGkAZwBoACAAcwBwAGUAZQBkACAAYwBhAHIAZABzAA==
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 14:19:51, S, Venkatraman wrote:
> On Tue, Sep 4, 2012 at 6:39 PM, Hebbar, Gururaja <gururaja.hebbar@ti.com> wrote:
> > HSMMC IP on AM33xx need a special setting to handle High-speed cards.
> > Other platforms like TI81xx, OMAP4 may need this as-well. This depends
> > on the HSMMC IP timing closure done for the high speed cards.
> >
> > From AM335x TRM (SPRUH73F - 18.3.12 Output Signals Generation)
> >
> > The MMC/SD/SDIO output signals can be driven on either falling edge or
> > rising edge depending on the SD_HCTL[2] HSPE bit. This feature allows
> > to reach better timing performance, and thus to increase data transfer
> > frequency.
> >
> > There are few pre-requisites for enabling the HSPE bit
> > - Controller should support High-Speed-Enable Bit and
> > - Controller should not be using DDR Mode and
> > - Controller should advertise that it supports High Speed in
> >   capabilities register and
> > - MMC/SD clock coming out of controller > 25MHz
> >
> 
> The patch is well written. But then, I don't see a need for a DT
> binding for this feature.

My reasons for DT Binding
1. Not all platforms using this driver has this bit (OMAP2)
2. Not all platforms using this driver needs this bit to be enabled (OMAP4)
3. Platforms which require this bit this to be set needs a method to inform 
driver.

In order to not disturb old/unsupported platforms, I chose this DT method.

> By definition, HS implies 25MHz or above, so that check seems to be
> redundant as well.

There are chances that the platform Max Clock output from HSMMC IP is < than 
25 MHz even if the card is High Speed. In such cases it would be better to
Confirm that the Clock output is actually > 25 MHz

Kindly correct me if I am wrong.

> Meanwhile, I'll check with HSPE enabled on OMAP.
> 
> Regards,
> Venkat.
> 


Regards, 
Gururaja
