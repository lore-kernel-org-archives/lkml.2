Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0GXMSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 08:18:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47275 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab0GXMSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 08:18:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C4ADA02.1050704@s5r6.in-berlin.de>
Date: Sat, 24 Jul 2010 14:18:10 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
CC: Jay Fenlason <fenlason@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.35-rc6 to 2.6.32.16: JuJu firewire issues
References: <4C49A291.20001@ribosome.natur.cuni.cz> <20100723180807.GA32319@redhat.com> <4C49E1A2.7050606@ribosome.natur.cuni.cz> <4C4A074D.4050305@s5r6.in-berlin.de> <4C4A9DD8.9080200@s5r6.in-berlin.de> <4C4AD65D.5090008@ribosome.natur.cuni.cz>
In-Reply-To: <4C4AD65D.5090008@ribosome.natur.cuni.cz>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Mokrejs wrote:
>   I tried in the morning to connect the IcyBox to this laptops internal
> Ricoh Co Ltd R5C552 IEEE 1394 Controller but had issues to power-up the drive
> at all. Not even using USB hub to supply power to it. I connected it to
> the ricoh chip via a 6 to 4 pin cable but also tried the not very good
> Kouwell 7004 PCMCIA card (which does not supply enough power unless I
> buy external, optional power supply of unknown specs and plug it into the
> PCMCIA card).

FireWire CardBus cards do not (or more precisely, must not) provide bus
power at all, unless if they have a power input port and a fitting PSU
is connected to it.  If a CardBus card puts power onto the FireWire bus
without any extra PSU connected, then this card is miswired and not spec
compliant.  A FireWire bus power provider is required to be able to
deliver 1.5 A current or more, at 8 V or more.  That can't be done via
CardBus.

4-pin FireWire ports OTOH do not provide bus power of course; they lack
the respective pins.

Some FireWire disk enclosures can optionally be powered via USB, but we
all know how unreliable USB bus power is.  Prefer either a dedicated PSU
or regular FireWire bus power.
-- 
Stefan Richter
-=====-==-=- -=== ==---
http://arcgraph.de/sr/
