Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0L1Gyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 01:54:53 -0500
Received: from tomasu.net ([64.85.170.234]:53449 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab0L1Gyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 01:54:52 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: linux-kernel@vger.kernel.org
Subject: strange fragmented udp packets
Date: Mon, 27 Dec 2010 23:54:43 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36.1+; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
Cc: linux-net@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012272354.44196.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been seeing a strange problem poke its head up since I switched from 
pfSense to a debian based shorewall firewall.

I've been un able to connect to my VOIP provider due to some oddly fragmented 
UDP sip packets not ever reaching the application layer on the provider's 
side.

I can't explain the packets getting fragmented (or I couldn't, see below). And 
only have a guess as to why my VOIP provider isn't seeing them, I've heard 
that some firewalls explicitly block fragmented UDP as its often used in DoS 
attacks, and for little else.

Here's at least what tcpdump has to say..

packet coming in:
23:38:26.136021 IP x.x.x.x.5060 > x.x.x.x.5060: SIP, length: 582

packet going out:
23:38:18.136085 IP x.x.x.x.5060 > x.x.x.x.5060: SIP, length: 544
23:38:18.136169 IP x.x.x.x > x.x.x.x: udp

...

After writing all that I've realized that the problem is the mtu on the nic 
attached to my cable modem, it was set to 576 for some odd reason. Changing 
the mtu to 1500 fixes my problem, but what is causing it to auto select an mtu 
of 576 anyhow? Could my modem be telling it that 576 is better for it?

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
