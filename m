Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab0KYOSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:18:23 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:54395 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0KYOSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:18:22 -0500
X-Greylist: delayed 2017 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2010 09:18:22 EST
From: nisse@lysator.liu.se (Niels =?iso-8859-1?Q?M=F6ller?=)
To: linux-kernel@vger.kernel.org
Subject: TCP_MAXSEG vs TCP/generic segmentation offload (tso/gso)
Date: Thu, 25 Nov 2010 14:44:44 +0100
Message-ID: <nny68hqzzn.fsf@stalhein.lysator.liu.se>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (usg-unix-v)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This is a slightly updated repost of a an October 21 mail to the
  linux-net list. Any hints or advice appreciated. /Niels ]

I have been observing large ethernet packets when generating TCP traffic
over a local ethernet, up to a bit over 20000 bytes, even though the
interface MTU is 1500 bytes.

Furthermore, I tried to use setsockopt with TCP_MAXSEG to limit the TCP
segment size further, to 1000 bytes, and that didn't have any effect.

When bugreporting a related problem to the debian kernel maintainers, I
was told that the behaviour may be linked to the use of TCP segmentation
offload (see http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=600286).

Disabling TSO and GSO using ethtool solves both problems: Generated
packets now are limited in size by both the interface MTU and the
segment size set with setsockopt. (Except the atl1c driver, where
ethtool -K eth0 tso off only results in a "Cannot set device tcp
segmentation offload settings: Operation not supported").

Before I try to write proper bug reports on specific network drivers (I
have seen problems with several network drivers on different machines,
unfortunately using different linux versions), I would like to know:

1. Is TCP_MAXSEG supposed to work at all with network drivers that do
   tcp segmentation offload?

2. If it is supposed to work, can someone give a rough sketch on how the
   per-socket segment size, set with setsockopt(... TCP_MAXSEG,...), is
   passed down to the driver and to the network hardware? I suspect it
   ought to be passed with each "pseudo-packet" to be transmitted.

I have spent some time searching the documentation and the net for
answers, without result, hence I'm posting to this list. I'm not
subscribed, so please cc any replies.

(Regarding packets larger than the interface MTU, that seems clearly
buggy to me, and I think I already know enough to be able to file proper
bug reports. And in the atl1c driver, it appears to have been fixed
between 1.0.0.1-NAPI and 1.0.1.0-NAPI).

Best regards,
/Niels

-- 
Niels Möller. PGP-encrypted email is preferred. Keyid C0B98E26.
Internet email is subject to wholesale government surveillance.

