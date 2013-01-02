Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3ABPN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:13:59 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:43138 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab3ABPN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:13:57 -0500
X-Greylist: delayed 998 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2013 10:13:57 EST
MIME-Version: 1.0
Date: Wed, 2 Jan 2013 16:13:56 +0100
Message-ID: <CAMXyS3Mvc8SkJxu4fCcUn+XpNcHrzEQ=M5w2eenVr-YKwa3AEQ@mail.gmail.com>
Subject: tg3 v3.123 in 100Mbps Full-Duplex mode with autoneg off
From: Marcin Miotk <marcinmiotk81@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While upgrading some gentoo servers from 3.0.9-gentoo to 3.4.11-gentoo
on HP Proliant DL320p machines I spotted an issue with tg3 driver.
I had port on a switch set to 100FD mode (autoneg off) and NIC set to
'speed 100 duplex full autoneg off' during bootup with ethtool - it's
been working this way for a very long time with no issues, however
after upgrading kernel I noticed that there is no connectivity at all
on the interface - the interface is up, configured (manually), but I'm
not able to ping any host - ethtool result below:


Settings for eth1:
    Supported ports: [ TP ]
    Supported link modes:   10baseT/Half 10baseT/Full
                            100baseT/Half 100baseT/Full
                            1000baseT/Half 1000baseT/Full
    Supported pause frame use: No
    Supports auto-negotiation: Yes
    Advertised link modes:  Not reported
    Advertised pause frame use: Symmetric
    Advertised auto-negotiation: No
    Speed: Unknown!
    Duplex: Unknown! (255)
    Port: Twisted Pair
    PHYAD: 1
    Transceiver: internal
    Auto-negotiation: off
    MDI-X: Unknown
    Supports Wake-on: g
    Wake-on: g
    Current message level: 0x000000ff (255)
                   drv probe link timer ifdown ifup rx_err tx_err
    Link detected: no


The NIC is working properly when I set the switchport to Autoneg +
100FD advertised and NIC is set to 'autoneg on' - on that config both
NIC and switch shows link as 100FD and there is no issues at all.
I compiled few kernel versions (also from vanilla sources) and the
source of the issue seems to be tg3 driver v3.123 - kernels with tg3
v3.122 works properly.
While browsing the tg3 changelog I noticed that there were some
changes made to autoneg in v3.123 + some code has been removed from
it.
Is this a known issue?

Regards,
Marcin Miotk
