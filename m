Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0IOPkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:40:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57130 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0IOPkB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:40:01 -0400
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: venki kaps <venkiece2005@gmail.com>, "Kanigeri, Hari" <h-kanigeri2@ti.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        "Hebbar, Shivananda" <x0hebbar@ti.com>,
        "Ramos Falcon, Ernesto" <ernesto@ti.com>,
        "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>,
        "Anna, Suman" <s-anna@ti.com>, "Gupta, Ramesh" <grgupta@ti.com>,
        "Gomez Castellanos, Ivan" <ivan.gomez@ti.com>,
        "ext-andriy.shevchenko@nokia.com" <ext-andriy.shevchenko@nokia.com>,
        "Uribe de Leon, Armando" <x0095078@ti.com>,
        "Chitriki Rudramuni, Deepak" <deepak.chitriki@ti.com>,
        "Menon, Nishanth" <nm@ti.com>,
        "ext-phil.2.carmody@nokia.com" <ext-phil.2.carmody@nokia.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 15 Sep 2010 10:39:49 -0500
Subject: RE: OMAP3 DSP MMU fault + off mode issue
Thread-Topic: OMAP3 DSP MMU fault + off mode issue
Thread-Index: ActU3bvFG7B2ud4SRmG+FK48vJncyQADHRww
Message-ID: <27F9C60D11D683428E133F85D2BB4A530450C3265B@dlee03.ent.ti.com>
References: <AANLkTikHM+o_FCgnVzGhs8UtQ_geXFzKNQpGSZiEN7sx@mail.gmail.com>
	<AANLkTimd_sRpOYaurOT0iSbfd0pMZvhxgUcaqbQvSobu@mail.gmail.com>
 <AANLkTimO1UK+WA8Mc3Myi3gWBpD=D7tXDOX104a8NMKW@mail.gmail.com>
In-Reply-To: <AANLkTimO1UK+WA8Mc3Myi3gWBpD=D7tXDOX104a8NMKW@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venki kaps wrote:
...
> 
> My problem is resolved.GPtimer7 was not reset during the MMU FAULT
> occurrence before the first power cycle. So this pending interrupt is
> preventing the system sleep entry. 
> Now it works fine after resetting Gptimer7 in pm suspend path.
> 

That's doesn't sound right, why the problem is not occurring after the first suspend-resume cycle.

DSP is in charge of clearing the overflow interrupt and if it is doing it after the first transition to Core OFF, why wouldn't be doing it for the first one.

Moreover from the logs sent internally (since it is the same issue and oddly the same resolution), the trace log dump printed is generated in the dsp after clearing the interrupts, so the problem could be the gptimer is configured to autoreload instead of oneshoot or the dsp write is not posted to clear the interrupt (which might be valid issues), but also they could happen after the first transition to OFF.

I'm sorry if I didn't ask you for logs but I was seeing this issue internally (and assumed you'll be in the same team of people :)), and given that more information was posted there than here..., but still, if available send the changes you have made.

Regards,

Omar

