Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0JOPEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:04:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:42228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab0JOPEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:04:50 -0400
Message-ID: <4CB86D8D.2000802@kernel.org>
Date: Fri, 15 Oct 2010 17:04:45 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, linux-pcmcia@lists.infradead.org,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH v2.6.36-rc7] serial_cs: drop spurious flush_scheduled_work()
 call
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Oct 2010 15:04:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serial_cs doesn't use the system workqueue.  Drop spurious
flush_scheduled_work() call.

This is to prepare for the deprecation and removal of
flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/serial/serial_cs.c |    5 -----
 1 file changed, 5 deletions(-)

Index: work/drivers/serial/serial_cs.c
===================================================================
--- work.orig/drivers/serial/serial_cs.c
+++ work/drivers/serial/serial_cs.c
@@ -363,11 +363,6 @@ static void serial_detach(struct pcmcia_
 	dev_dbg(&link->dev, "serial_detach\n");

 	/*
-	 * Ensure any outstanding scheduled tasks are completed.
-	 */
-	flush_scheduled_work();
-
-	/*
 	 * Ensure that the ports have been released.
 	 */
 	serial_remove(link);
