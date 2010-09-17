Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0IQXmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 19:42:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45044 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0IQXmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 19:42:16 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C93FCC7.9040406@s5r6.in-berlin.de>
Date: Sat, 18 Sep 2010 01:41:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] FireWire fixes
References: <tkrat.b186ea3830d71c45@s5r6.in-berlin.de> <1284764773.2804.7.camel@maxim-laptop>
In-Reply-To: <1284764773.2804.7.camel@maxim-laptop>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky wrote:
> Running new stack on the laptop + old stack on the desktop gave me about
> 18-30 Mbit/s speeds varying all the time.
> Running both with the new stack results in corrupted packets and sftp
> exits immediately.

firewire-net, the IP over 1394 driver, is still marked as experimental not
because somebody forgot to remove that mark but because we mean it.  But so is
its older counterpart, eth1394.  Both eth1394 and firewire-net are chronically
 underused and undermaintained.

> The problems I so hoped to be fixed in new stack still persist:
> 
> Cable disconection/reconnection still results in the link loss till
> ifconfig down/up.
> 
> Suspend/resume also results in the link loss.

Sounds like something that shouldn't be too hard to fix by anybody who can
spare the time.  Surely a higher-level problem somewhere in firewire-net.

> Driver still has panics on some occasions.

At the moment I suspect that this OTOH might not be a firewire-net problem but
possibly a race in firewire-ohci which is only triggered by workload as
firewire-net imposes it (heavy AT context usage).
-- 
Stefan Richter
-=====-==-=- =--= =--=-
http://arcgraph.de/sr/
