Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1G0SMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 14:12:12 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:52029 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565Ab1G0SMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 14:12:10 -0400
MIME-Version: 1.0
In-Reply-To: <20110727110740.GB300@sirena.org.uk>
References: <marcus.folkesson@gmail.com>
	<1311762767-20263-1-git-send-email-marcus.folkesson@gmail.com>
	<1311762767-20263-3-git-send-email-marcus.folkesson@gmail.com>
	<20110727110740.GB300@sirena.org.uk>
Date: Wed, 27 Jul 2011 20:12:09 +0200
Message-ID: <CAM8FrKJPYU3n1EEhEMoJNeQhBYnJzqwK0HOtjt1-0TEhr9NaFA@mail.gmail.com>
Subject: Re: [PATCH 2/3] regulator: tps65023: Setting correct core regulator
 for tps65021
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/27 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Jul 27, 2011 at 12:32:46PM +0200, Marcus Folkesson wrote:
>> TPS65023 is using VDCDC1 as core regulator and TPS65021 is using VDCDC3.
>
> What is "core regulator" to the regulator chip itself?

The tps6502x has 3 step down converters, VDCDC[1-3], which two has
fixed voltages and the third is adjustable with the i2c interface.
The adjustable converter is for controlling the core-voltage to a
processor and is referred as "core" in the datasheet. Therefore a
"core regulator".

A better name for "core regulator" should be "core converter" or
something. I'm apologize for the confusing name.


>> Core-regulator, voltage-tables and size of voltage-table may differ between
>> different regulators. All those three is now passed as driver data.
>
> No, the driver should be able to figure out for itself what regulators
> are on the chip purely by knowing what chip it's talking to.  If there
> is some configuration on the board from selection of passives or similar
> the platform data should reflect how that's done (eg, supply the
> relevant values for the passives).
>

The information is passed by the driver_data field in the device
table, so the driver itself knows what chip it is talking to.
In the original driver, only the voltage table was passed this way, I
just added the "core_regulator" and the size of voltage-table in the
same way.
