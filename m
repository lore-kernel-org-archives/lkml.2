Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1DUPXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:23:50 -0400
Received: from trent.utfs.org ([194.246.123.103]:38566 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab1DUPXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:23:48 -0400
Date: Thu, 21 Apr 2011 08:23:46 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: 622352@bugs.debian.org
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug#622352: /sbin/udevd: error writing to queue file: No space
 left on device
Message-ID: <alpine.DEB.2.01.1104210814080.18728@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same here with 2.6.39-rc4: udevd spinning like crazy and sometimes my 
10MB /dev filesystem seems to be filled by:

-rw-r--r-- 1 root root 7.0M Apr 21 08:17 /dev/.udev/queue.bin

accompanied by:

Apr 20 22:25:10 alice udevd[472]: error writing to queue file: No space left on device
Apr 20 22:25:10 alice udevd[472]: failed to create queue file: No space left on device

I also see the OOM killer reaping processes which were running just fine 
with 2.6.38. I also see the "hanging" bootprocess Ralf mentioned in 
#622352. Pressing CTRL-C makes it continue booting.

I suspect that it's more a kernel issue. Ralf is on 2.6.39-rc2 and said 
that 2.6.38.2 was ok, so somewhere in between something bad happened.

Christian.
-- 
BOFH excuse #277:

Your Flux Capacitor has gone bad.
