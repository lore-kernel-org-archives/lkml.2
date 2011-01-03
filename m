Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab1ACXsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 18:48:05 -0500
Received: from tomasu.net ([64.85.170.234]:44286 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab1ACXsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 18:48:03 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: linux-kernel@vger.kernel.org
Subject: Re: strange fragmented udp packets
Date: Mon, 3 Jan 2011 16:47:55 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36.1+; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
Cc: linux-net@vger.kernel.org
References: <201012272354.44196.thomas@fjellstrom.ca>
In-Reply-To: <201012272354.44196.thomas@fjellstrom.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101031647.56077.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On December 27, 2010, Thomas Fjellstrom wrote:
> I've been seeing a strange problem poke its head up since I switched from
> pfSense to a debian based shorewall firewall.
> 
> I've been un able to connect to my VOIP provider due to some oddly
> fragmented UDP sip packets not ever reaching the application layer on the
> provider's side.
> 
> I can't explain the packets getting fragmented (or I couldn't, see below).
> And only have a guess as to why my VOIP provider isn't seeing them, I've
> heard that some firewalls explicitly block fragmented UDP as its often
> used in DoS attacks, and for little else.
> 
> Here's at least what tcpdump has to say..
> 
> packet coming in:
> 23:38:26.136021 IP x.x.x.x.5060 > x.x.x.x.5060: SIP, length: 582
> 
> packet going out:
> 23:38:18.136085 IP x.x.x.x.5060 > x.x.x.x.5060: SIP, length: 544
> 23:38:18.136169 IP x.x.x.x > x.x.x.x: udp
> 
> ...
> 
> After writing all that I've realized that the problem is the mtu on the nic
> attached to my cable modem, it was set to 576 for some odd reason. Changing
> the mtu to 1500 fixes my problem, but what is causing it to auto select an
> mtu of 576 anyhow? Could my modem be telling it that 576 is better for it?

Anyone have a hint? I've checked with my sip provider and they don't have 
iptables set up, so nothing should be getting in the way of these packets. For 
some reason they just aren't reaching the SIP server.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
