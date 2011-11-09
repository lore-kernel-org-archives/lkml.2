Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab1KIUed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:34:33 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13160 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab1KIUe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:34:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 09 Nov 2011 12:34:28 -0800
From: Stephen Warren <swarren@nvidia.com>
To: "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 9 Nov 2011 12:34:27 -0800
Subject: pinctrl discussions @ Linaro Connect, and also requesting GPIOs
Thread-Topic: pinctrl discussions @ Linaro Connect, and also requesting GPIOs
Thread-Index: AcyfHfZoyc1ePaSxSqKVkm78S8zniA==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17408051C2@HQMAIL01.nvidia.com>
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

Linus,

I'm curious about any pinctrl-related discussions that happened at Linaro
Connect. Are you able to summarize any discussions/decisions, or point me
at some existing summary? Especially anything to do with the new pin config
options, possibly extending the mapping table to control them, etc.

On the topic of pinctrl:

Many drivers currently call gpio_request(). This is defined /not/ to
perform any pinmux manipulation. On Tegra, the pinmux is set up due to
board files calling tegra_gpio_enable() before probing drivers. I'm
wondering:

a) Should drivers explicitly call pinmux_request_gpio() before calling
gpio_request() instead, so that the board files don't have to set this up
first?

b) Shouldn't this be hidden inside the pinctrl's mapping table; if a driver
needs to set up non-GPIO pinmux options, it's all done in pinmux_get() and
pinmux_enable(), whereas for GPIOs they need to use the other API. Can we
unify this?

I think extending the mapping table to be able to represent either the
existing mux configuration, or GPIO allocation, might make sense. In fact,
if we do that, perhaps pinmux_{request,free}_gpio() wouldn't even be needed?

What are your thoughts?

-- 
nvpublic

