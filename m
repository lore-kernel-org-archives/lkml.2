Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab1CaVsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:48:18 -0400
Received: from host171.canaca.com ([67.55.55.225]:51788 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab1CaVsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:48:17 -0400
Message-ID: <f20a67da72099b51d6593c9d31933f4d.squirrel@host171.canaca.com>
Date: Thu, 31 Mar 2011 17:48:13 -0400
Subject: Poulsbo I2C - /dev/i2c not seen when loading i2c-dev
From: simon@mungewell.org
To: linux-input@vger.kernel.org
Cc: "Jacob Pan" <jacob.jun.pan@intel.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I'm hoping that someone here can help. I am trying to get userland access
to the I2C bus(es) on an embedded system, however recent kernels (ie.
2.6.38) are not 'loading' any buses when I 'modprobe i2c-dev'.

Going back to “2.6.32” I am able to see 1 bus, and 'i2cdetect 0' shows a
single device sitting at address 0x69 (which I believe to EEPROM on the
wifi card... not confirmed).


The board is built around the Poulsbo and therefore using the 'i2c-isch'
driver.

Reviewing the schematic I see that there are several buses, each going to
individual components:
IT8516 U5/110+111 -> LTC1760 U6/18+22 [battery charger – 0x1A/0x12]
IT8516 U5/115+116 -> W83L771 U60/8+7 [thermal sensor – 0x18??]
IT8516 U5/117+118 -> LSM303DLH U64/19+20 [accel/compass – 0x19]
POULSBO U2/G37+H38 -> PCI Express Socket

I am a little dismayed by the comment in 'i2c-isch.c' which suggest it can
handle only one i2c bus at any time.
--
/*
   Supports:
	Intel SCH chipsets (AF82US15W, AF82US15L, AF82UL11L)
   Note: we assume there can only be one device, with one SMBus interface.
*/
--

This seems to correlate to these comments:
http://www.linuxforums.org/forum/programming-scripting/175147-smbus-intel-sch-us15w.html

Can anyone confirm whether this is actually the case, and whether it is
possible to configure it to use a different controller address. One would
expect this to be a module option I guess, however it doesn't seem to take
any.

Many thanks in advance,
Simon.

