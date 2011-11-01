Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1KAQaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:30:10 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:53440 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab1KAQaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:30:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1320164952!17955866!72
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>,
        =?iso-8859-1?Q?=27H=E5vard_Skinnemoen=27?= <hskinnemoen@gmail.com>
CC: "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 1 Nov 2011 11:29:32 -0500
Subject: RE: [PATCH] i2c-gpio.c: correct logic of pdata->scl_is_open_drain
Thread-Topic: [PATCH] i2c-gpio.c: correct logic of pdata->scl_is_open_drain
Thread-Index: AcyYZE/mlvGDbQhsR7a2xIKWGvqqQgABwoQgABHIWCA=
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F39DF77673@AUSP01VMBX24.collaborationhost.net>
References: <EF2E73589CA71846A15D0B2CDF79505D087B34BE51@wm021.weinmann.com>
	<CAF8ieYXPMgUzekth7PGxC3AgYNKac-HQ21D3vvB5J3SLOatmfQ@mail.gmail.com>
	<EF2E73589CA71846A15D0B2CDF79505D087B34BE8B@wm021.weinmann.com>
	<CAF8ieYWY2RwkgPERgagvw2bby8Y+UFgrYr3zPOb27e=bfOH-vg@mail.gmail.com>
 <EF2E73589CA71846A15D0B2CDF79505D087B34BEE2@wm021.weinmann.com>
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B34BEE2@wm021.weinmann.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 01, 2011 1:02 AM, Voss, Nikolaus wrote:
>> It is never correct to use push-pull I/O for i2c, so the flag does not
>> specify the desired behavior of the driver, it specifies what the
>> hardware has been configured to do so that the driver can choose the
>> cheapest way to do open-drain I/O.
>
> Ok, seems rather logical after all.
>
>> 
>> And even if you could argue that the flag should be inverted, it has
>> had the same meaning since the driver was introduced several years
>> ago, so changing it now will break every single platform which
>> currently uses i2c-gpio.
>
> I completely agree.
>

Just for the record...

The GPIO pins used for I2C on the ep93xx platform can be configured as
open-drain I/O pins.  When they are, and external pull-ups are applied
to the signals, the I2C bus works correctly when the "is_open_drain"
flags are set.  If the pull-ups are missing the bus does not work.
If the "is_open_drain" flags are not set, the I2C bus works correctly
regardless of the existence of the pull-ups.

Based on that I think the i2c-gpio driver's use of the "is_open_drain"
flags is correct.

Regards,
Hartley
