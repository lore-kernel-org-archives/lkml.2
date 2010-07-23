Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab0GWVvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 17:51:09 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42617 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab0GWVvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 17:51:06 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C4A0EB5.4020405@s5r6.in-berlin.de>
Date: Fri, 23 Jul 2010 23:50:45 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
CC: Jay Fenlason <fenlason@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.35-rc6 to 2.6.32.16: JuJu firewire issues
References: <4C49A291.20001@ribosome.natur.cuni.cz> <20100723180807.GA32319@redhat.com> <4C49E1A2.7050606@ribosome.natur.cuni.cz> <20100723192646.GB32319@redhat.com> <4C49F955.1040308@ribosome.natur.cuni.cz> <4C4A0CAF.9060308@s5r6.in-berlin.de>
In-Reply-To: <4C4A0CAF.9060308@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Your dmesg shows multiple bus resets and one of the three nodes
> disappearing from the bus from time to time.  This points to a probelm
> at the physical layer (i.e. highly unreliable hardware) which
> fundamentally cannot be solved by software.

PS:  If you want, you can for example run the small utility
"firecontrol" (requires libraw1394) in a console while you have the
FireWire disk attached.  Firecontrol will show all bus resets that
happen as well as how many nodes are present on the bus after each reset.

During usage of a FireWire disk, there should be only about two or so
bus resets early on when the disk is plugged in, but then not anymore.
The drivers do handle subsequent bus resets (firewire-sbp2 +
firewire-core much better than sbp2 + ieee1394, obviously) but they
cannot do much if very frequent bus resets happen and the target node
even disappears from the bus due to electrical problems or whatever reasons.

According to your dmesg, I expect firecontrol to show series of resets,
some of them with a node going away and coming back.  The most likely
cause for that is buggy or defective hardware.
-- 
Stefan Richter
-=====-==-=- -=== =-===
http://arcgraph.de/sr/
