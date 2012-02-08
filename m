Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2BHObx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:31:53 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54333 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab2BHObv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:31:51 -0500
MIME-Version: 1.0
Date: Wed, 8 Feb 2012 15:31:50 +0100
Message-ID: <CACW_hTY41xZV6d0W2Z2kRfKOfa+RSQ-A-BoZsZwNXSQmeF_6Gg@mail.gmail.com>
Subject: drivers/net/phy/phy.c issue
From: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
To: afleming@freescale.com, macro@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I found an issue with drivers/net/phy/phy.c
As I could not identify a maintainer for this file I decided to mail
it to the above addressees.
Apologies upfront if it is inappropriate.

The issue:

My network interface was configured as 10Mbit, full duplex, autonegotiate off.
If the cable is unplugged after 10 seconds or so the interface drops
to half duplex and the message:
Trying 10/HALF
is printed. This message comes (if I am correct from the function
phy_force_reduction in drivers/net/phy/phy.c

Maybe this is still ok, however if I reconnect my network cable the
interface remains configured as 10 Mbit, half duplex.
I had expected/assumed that it would go back to 10 Mbit, full duplex.

If I try the same with a 1Gbit full duplex link with autonegotiate on,
the link also drops to half duplex whenever the cable is
disconnected. However reconnecting the cable then brings the interface
back to full duplex again.

Not sure what is wrong (if the interface should not be dropped to half
or get back to full) and even less an idea how to fix it,
but wanted to report it anyway, in the hope someone can shed a light
on this and/or fix it.

Best regards, Frans.

PS: I'm not on lkml (way too much mails for me), so please keep me on Cc
