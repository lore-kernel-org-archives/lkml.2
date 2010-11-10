Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab0KJKcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:32:33 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:33076 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0KJKcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:32:31 -0500
Subject: PROBLEM: first read of /dev/mcelog fails
From: Jon Masters <jonathan@jonmasters.org>
To: andi@firstfloor.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Wed, 10 Nov 2010 05:32:31 -0500
Message-ID: <1289385151.3916.554.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

I recently took some time to look at the daemon side of mcelog. I found
a few issues with that[0] that I will detail in a separate mail, but I
am more concerned that in recent kernels, the first read() of the mcelog
device performed by mcelog after boot always fails. 100% reproducible on
several machines - mcelog client always bombs out in process() due to
getting a "no such device" error from the kernel read attempt.
The /dev/mcelog device exists, but the first read fails.

Can you do a fresh boot, run mcelog, and see what I mean?

Jon.

[0] ignoredev not documented, cache-error-trigger uses $CPUS_AFFECTED
when it should be $AFFECTED_CPUS, mcelog-client socket is always created
no matter what the config says (and not deleted on shutdown).


