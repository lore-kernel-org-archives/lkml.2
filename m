Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab2GDQuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:50:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56351 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab2GDQuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:50:08 -0400
X-Sasl-enc: 15LcwPtpd92Km36d2P4rI1hQMI/Uxu4MUg9JqKahRkxs 1341420606
Date: Wed, 4 Jul 2012 13:50:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ibm-acpi-devel] ethernet-related thermal emergency on
 Thinkpad x60
Message-ID: <20120704165004.GB7613@khazad-dum.debian.net>
References: <20120704141756.GA2089@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120704141756.GA2089@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jul 2012, Pavel Machek wrote:
> When using nework interface (eth0), machine starts to behave
> weird. Like... complete freeze, then poweroff, then it hangs on boot
> (initializing ACPI) until I let it to cool down... and I'm not even
> using gigabit speed.
> 
> Did anyone see it? Any ideas? Should I attempt to open it and clean
> the dust?

Opening it up and cleaning things is always a good idea.  Some intel
boxes have the GbEth MAC inside the chipset, so it is also worth
checking whether the thermal contact between heatsink and chipset is
operating properly (or just replace the old thermal compounts with Artic
Silver 5 or some other non-reactive, extremely high quality compound
that is suitable for the rapid thermal cycles of laptops).

> thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is extremely hot!
> thinkpad_acpi: temperatures (Celsius): 88 49 N/A 82 40 N/A 40 N/A 52 61 N/A N/A N/A N/A N/A N/A

My guess is that the 82°C reading on the fourth sensor is the problem,
althouhg the CPU is also quite hot.  That sensor is usually the GPU, but
if your thinkpad has an integrated GPU, it is likely to have been used
for the northbridge/chipset.

It can also be a shortcircuity in the ethernet PHY (either the chip, or
some of the analog auxiliary circuitry).  This is repairable by an
skilled surface-mount technician if he can get his hands in the
schematics and source the replacement components, but if you ask Lenovo
about it, they will want to replace your entire planar card
(motherboard)...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
