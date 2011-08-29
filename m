Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab1H2RGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:06:23 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:34965 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322Ab1H2RGW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:06:22 -0400
From: Philip Rakity <prakity@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "cbou@mail.ru" <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "adharmap@codeaurora.org" <adharmap@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 29 Aug 2011 10:03:47 -0700
Subject: [PATCH 0/3] New Properties for Battery Management
Thread-Topic: [PATCH 0/3] New Properties for Battery Management
Thread-Index: AcxmbZ2zdl7kKSn7RuSVvj2KLQ+NfA==
Message-ID: <6B0731AA-E7C9-4AE9-800A-90E9A0B88E26@marvell.com>
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


This patch set adds two new properties for power.

POWER_SUPPLY_PROP_CHARGE_TO_USE

and

POWER_SUPPLY_PROP_VOLTAGE_TO_USE

Batteries (drivers) that can supply this information implement these new properties.

In some cases (dumb batteries) the information may not be available directly from the battery
but is available via platform specific code that has the rules for charge/voltage specified.
In the later case the battery driver will request the information from the platform specific code.
For our system, we calculate this information based on the current voltage/charge and temperature.

The supplied_to field specifies the devices that are supplied power..   In our case we have an 
AC/DC adapter that supplies DC  to a intersil isl9519q charger which supplies charge to the
battery.  The battery is managed by a max17042.  The intersil charger asks the max17042
what charge and voltage to use.  (For each driver in the supplied_to list get the properties 
charge and voltage to use).

  This information is calculated by
the max17042 driver and returned to the intersil charger which adjusts its charging accordingly.


PATCH 1/3]  power: add two properties: charge_to_use and  voltage_to_use
> Implements the new properties

[PATCH 2/3] power: support intersil isl9519q charger driver
> intersil driver with support for these properties

[PATCH 3/3]  power: max17042:  allow battery to return charge/voltage  to use
>added support to return these properties


