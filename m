Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab1ADJIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:08:23 -0500
Received: from lo.gmane.org ([80.91.229.12]:52836 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab1ADJIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:08:20 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: strange fragmented udp packets
Date: Tue, 4 Jan 2011 08:50:54 +0000
Message-ID: <ek3bv7-3m6.ln1@chipmunk.wormnet.eu>
References: <201012272354.44196.thomas@fjellstrom.ca> <201101031647.56077.thomas@fjellstrom.ca>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.6-20100522 ("Lochruan") (UNIX) (Linux/2.6.32-5-sparc64-smp (sparc64))
Cc: linux-net@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
>
>> I can't explain the packets getting fragmented (or I couldn't, see below).
>> And only have a guess as to why my VOIP provider isn't seeing them, I've
>> heard that some firewalls explicitly block fragmented UDP as its often
>> used in DoS attacks, and for little else.
>> 
>> Here's at least what tcpdump has to say..
>> 
>> packet coming in:
>> 23:38:26.136021 IP x.x.x.x.5060 > x.x.x.x.5060: SIP, length: 582
>> 
>> packet going out:
>> 23:38:18.136085 IP x.x.x.x.5060 > x.x.x.x.5060: SIP, length: 544
>> 23:38:18.136169 IP x.x.x.x > x.x.x.x: udp
>> 
>> ...
>> 
>> After writing all that I've realized that the problem is the mtu on the nic
>> attached to my cable modem, it was set to 576 for some odd reason. Changing
>> the mtu to 1500 fixes my problem, but what is causing it to auto select an
>> mtu of 576 anyhow? Could my modem be telling it that 576 is better for it?
> 
> Anyone have a hint? I've checked with my sip provider and they don't have 
> iptables set up, so nothing should be getting in the way of these packets. For 
> some reason they just aren't reaching the SIP server.
> 
pmtu?

Play around with the handy utility tracepath (and tracepath6) to 
<phun>discover</phun> more!

Cheers

-- 
Alexander Clouter
.sigmonster says: May you have many handsome and obedient sons.

