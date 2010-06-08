Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0FHJzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:55:54 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:45600 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab0FHJzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:55:53 -0400
Message-ID: <4C0E13A7.20402@msgid.tls.msk.ru>
Date: Tue, 08 Jun 2010 13:55:51 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: xfs, aacraid 2.6.27 => 2.6.32 results in 6 times slowdown
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I've got a.. difficult issue here, and am asking if anyone else
has some expirence or information about it.

Production environment (database).  Machine with an Adaptec
RAID SCSI controller, 6 drives in raid10 array, XFS filesystem
and Oracle database on top of it (with - hopefully - proper
sunit/swidth).

Upgrading kernel from 2.6.27 to 2.6.32, and users starts screaming
about very bad performance.  Iostat reports increased I/O latencies,
I/O time increases from ~5ms to ~30ms.  Switching back to 2.6.27,
and everything is back to normal (or, rather, usual).

I tried testing I/O with a sample program which performs direct random
I/O on a given device, and all speeds are actually better in .32
compared with .27, except of random concurrent r+w test, where .27
gives a bit more chances to reads than .32.  Looking at the synthetic
tests I'd expect .32 to be faster, but apparently it is not.

This is only one machine here which is still running 2.6.27, all the
rest are upgraded to 2.6.32, and I see good performance of .32 there.
But this is also the only machine with hardware raid controller, which
is onboard and hence not easy to get rid of, so I'm sorta forced to
use it (I prefer software raid solution because of numerous reasons).

One possible cause of this that comes to mind is block device write
barriers.  But I can't find when they're actually implemented.

The most problematic issue here is that this is only one machine that
behaves like this, and it is a production server, so I've very little
chances to experiment with it.

So before the next try, I'd love to have some suggestions about what
to look for.   In particular, I think it's worth the effort to look
at write barriers, but again, I don't know how to check if they're
actually being used.

Anyone have suggestions for me to collect and to look at?

Thank you!

/mjt
