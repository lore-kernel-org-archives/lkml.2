Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2KUOMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:12:48 -0500
Received: from v37049.1blu.de ([89.202.2.49]:50811 "EHLO v37049.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab2KUOMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:12:47 -0500
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2012 09:12:47 EST
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, patrik.r.jakobsson@gmail.com,
        christian.gmeiner@gmail.com
Date: Wed, 21 Nov 2012 15:04:42 +0100
Message-ID: <20121121140442.782733@zweiblum.hodek.net>
From: roman@hodek.net
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Mailer: RoMail 2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've found your discussion about a gma500 Atom E6xx graphics device with PCI
ID 0x4108. I'm currently working on such a box, too.

There are two variants of my hardware, one with LVDS output for smaller
panels, and one with a Chrontel 7308 SDVO->LVDS converter for larger ones. My
HW developer says the platform is called "Little Bay" and similar to Queens
Bay.

Anyway, the small LVDS one works fine so far, at least when I hardcode the
panel resolution (there's no VBT etc. in BIOS yet). However, the SDVO one
stays black. No wonder, as there's no SDVO code in the Oaktrail part of the
driver.

So I tried to add this... and simply started with adding a call to
psb_intel_sdvo_init() in oaktrail_output_init(), to see what happens. The
result: it doesn't find anything :-( I could track problems down to the point
that the SDVO i2c registers seem to be the wrong ones.

At the known offsets for i2c regs (0x5100 and on) I see only 0xffffffff, so
probably these registers are not present or somewhere else on my platform.

Does anybody of you have any infos on this? How can I get further?
Thanks for any help in advance!

Roman


PS: Please keep me in Cc:, I'm not subscribed to LKML.

