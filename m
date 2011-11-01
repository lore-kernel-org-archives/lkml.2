Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab1KAGQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 02:16:17 -0400
Received: from portal.weinmann.de ([62.8.140.122]:19917 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1KAGQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 02:16:16 -0400
X-Greylist: delayed 978 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Nov 2011 02:16:15 EDT
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: =?iso-8859-1?Q?=27H=E5vard_Skinnemoen=27?= <hskinnemoen@gmail.com>
CC: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>
Date: Tue, 1 Nov 2011 06:59:46 +0100
Subject: RE: [PATCH] i2c-gpio.c: correct logic of pdata->scl_is_open_drain
Thread-Topic: [PATCH] i2c-gpio.c: correct logic of pdata->scl_is_open_drain
Thread-Index: AcyYEyFaeOdsdTETSpy++r5kZdozVQARnrxg
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B34BE8B@wm021.weinmann.com>
References: <EF2E73589CA71846A15D0B2CDF79505D087B34BE51@wm021.weinmann.com>
 <CAF8ieYXPMgUzekth7PGxC3AgYNKac-HQ21D3vvB5J3SLOatmfQ@mail.gmail.com>
In-Reply-To: <CAF8ieYXPMgUzekth7PGxC3AgYNKac-HQ21D3vvB5J3SLOatmfQ@mail.gmail.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Havard,

> {sda,scl}_is_open_drain indicates that the GPIO hardware is set up to
> do open drain so the software doesn't have to, i.e.
> gpio_set_value(pin, 1) will turn off the output driver rather than
> drive the pin high, so the _val functions will do the right thing.

gpio_set_value(pin, 1) drives the output high same as
gpio_direction_output(pin, 1) does (documented in Documentation/gpio.txt),
so the gpio will be changed from open-drain to push-pull.

In contrast, gpio_direction_input(pin) will turn off the output driver.

Open-drain io is bound to "!is_open_drain" and push-pull io is bound to
"is_open_drain", so I still think this should be the other way round.

Niko

