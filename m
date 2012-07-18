Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2GRPAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 11:00:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41184 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2GRPAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 11:00:47 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: DT support for Low threshold brightness in backlight.
Thread-Topic: DT support for Low threshold brightness in backlight.
Thread-Index: Ac1k9cMzP69rlsYeQOixAIQAq5TG9w==
Date: Wed, 18 Jul 2012 14:59:32 +0000
Deferred-Delivery: Wed, 18 Jul 2012 14:59:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E96A842@DBDE01.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In pwm-backlight driver low threshold brightness support in DT is not
present. Do you have any plans in such direction?

I am planning to add support for the same but want to avoid duplication
of work.

Below scenario describes need for it:
On some boards panel backlight is OFF at low end of brightness scale.
So with Low threshold brightness we can have linear scale in brightness
(Though the actual brightness scale is changes to Low threshold
brightness value instead of 0).

Example with Low threshold brightness
	pwms = <&pwm 0 50000>;
	brightness-levels = <0 2 4 8 16 32 64 128 255>;
	default-brightness-level = <6>;
	brightness_threshold_level = <50>;

It can also be achieved without Low threshold brightness as below

	pwms = <&pwm 0 50000>;
	brightness-levels = <0 51 53 56 62 75 101 152 255>; 
	default-brightness-level = <6>;

But brightness-levels won't be uniformly divided.

So it is good to have low threshold DT support for backlight.

Thanks
Avinash Philip



