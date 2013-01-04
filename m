Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3AEAKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 19:10:14 -0500
Received: from cassarossa.samfundet.no ([129.241.93.19]:37991 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3AEAKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 19:10:12 -0500
X-Greylist: delayed 1345 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jan 2013 19:10:11 EST
Date: Sat, 5 Jan 2013 00:47:43 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-kernel@vger.kernel.org
Subject: PEBS (in perf) stopped working from 3.6 -> 3.7
Message-ID: <20130104234743.GA12331@uio.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: Linux 3.7.1 on a x86_64
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please Cc me on any replies; I'm not subscribed to lkml]

Hi,

I recently upgraded from 3.6.5 to 3.7.1 to get around some MM issues that
have been bothering me. However, it appears it broke PEBS:

  pannekake:/usr/src/linux-3.7.1# perf record -a -e cycles:pp

  Error: sys_perf_event_open() syscall returned with 95 (Operation not supported).  /bin/dmesg may provide additional information.

  Fatal: No hardware sampling interrupt available. No APIC? If so then you can boot the kernel with the "lapic" boot parameter to force-enable it.

Non-precise tracing works fine. This used to work in 3.6.5, and I used make
oldconfig (not that I can find any .config settings that would seem relevant
either). I certainly have APIC. There's nothing in dmesg about the error.
I'm using perf built from the same kernel tree (ie., 3.7.1).

This is on a dual Xeon E5520 (ie. Westmere), on a Supermicro board.

/* Steinar */
-- 
Chief, Tech:Server
http://www.sesse.net/
