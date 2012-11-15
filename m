Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab2KOIcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:32:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41184 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab2KOIcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:32:15 -0500
Message-ID: <1352968293.10872.51.camel@cumari.coelho.fi>
Subject: 32kHz clock removal causes problems omap_hsmmc
From: Luciano Coelho <coelho@ti.com>
To: <svenkatr@ti.com>, <linux-omap@vger.kernel.org>
CC: <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Date: Thu, 15 Nov 2012 10:31:33 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since the 32KHz clock was removed from the twl-regulator (0e8e5c34
regulator: twl: Remove references to 32kHz clock from DT bindings),
we've been having problems with our wl12xx chip that is connected
through the omap_hsmmc.

Our card simply doesn't get added to the system and we get lots of
-ETIMEOUTs during mmc_attach.  If I revert 0e8e5c34 (plus a couple of
associated patches), everything works fine.

I've been using a Blaze device with a WiLink 1283 chip connected in the
COM (internal) port.  The funny thing is that I don't have the same
problem with a WiLink 1853 chip (which is connected externally to
another Blaze).

Does anyone know what the problem could and how to fix it?

This is a regression that has been there since 3.6-rc1.

--
Cheers,
Luca.

