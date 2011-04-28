Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684Ab1D1LIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 07:08:39 -0400
Received: from smtp.nokia.com ([147.243.128.26]:18728 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab1D1LIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 07:08:38 -0400
From: <kalle.jokiniemi@nokia.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <lrg@slimlogic.co.uk>, <mchehab@infradead.org>, <svarbatov@mm-sol.com>,
        <saaguirre@ti.com>, <grosikopulos@mm-sol.com>,
        <vimarsh.zutshi@nokia.com>, <Sakari.Ailus@nokia.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: RE: [RFC] Regulator state after regulator_get
Thread-Topic: [RFC] Regulator state after regulator_get
Thread-Index: AQHMBYvuahnBNc70lUOziC4VKJ5gv5RzHHpw
Date: Thu, 28 Apr 2011 11:08:08 +0000
Message-ID: <9D0D31AA57AAF5499AFDC63D6472631B09C858@008-AM1MPN1-036.mgdnok.nokia.com>
References: <9D0D31AA57AAF5499AFDC63D6472631B09C76A@008-AM1MPN1-036.mgdnok.nokia.com>
 <20110428100629.GA14494@opensource.wolfsonmicro.com>
In-Reply-To: <20110428100629.GA14494@opensource.wolfsonmicro.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.212.101]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 28 Apr 2011 11:08:10.0181 (UTC) FILETIME=[8F25A750:01CC0594]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

 > -----Original Message-----
 > From: ext Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
 > Sent: 28. huhtikuuta 2011 13:06
 > To: Jokiniemi Kalle (Nokia-SD/Tampere)
 > Cc: lrg@slimlogic.co.uk; mchehab@infradead.org; svarbatov@mm-sol.com;
 > saaguirre@ti.com; grosikopulos@mm-sol.com; Zutshi Vimarsh (Nokia-
 > SD/Helsinki); Ailus Sakari (Nokia-SD/Helsinki); linux-kernel@vger.kernel.org;
 > linux-media@vger.kernel.org
 > Subject: Re: [RFC] Regulator state after regulator_get
 > 
 > On Thu, Apr 28, 2011 at 09:01:03AM +0000, kalle.jokiniemi@nokia.com wrote:
 > 
 > > If the device driver using the regulator does not enable and disable the
 > > regulator after regulator_get, the regulator is left in the state that it was
 > > after bootloader. In case of N900 this is a problem as the regulator is left
 > > on to leak current. Of course there is the option to let regulator FW disable
 > > all unused regulators, but this will break the N900 functionality, as the
 > > regulator handling is not in place for many drivers.
 > 
 > You should use regulator_full_constraints() if your board has a fully
 > described set of regulators.  This will cause the framework to power
 > down any regulators which aren't in use after init has completed.  If
 > you have some regulators with no consumers or missing consumers you need
 > to mark them as always_on in their constraints.

I don't have a full set of regulators described, that's why things broke when
I tried the regulator_full_constraints call earlier. But I don't think it would be too
big issue to check the current after boot configuration and define all the
regulators as you suggest. I will try this approach.

 > 
 > > So reset the regulator on first regulator_get call to make
 > > sure that any regulator that has users is not left active
 > > needlessly.
 > 
 > This would cause lots of breakage, it would mean that all regulators
 > that aren't always_on would get bounced off at least once during startup
 > - that's not going to be great for things like the backlight.

OK, this is not a viable solution.

Thanks for the comments,
Kalle

