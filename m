Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0DVWvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:51:48 -0400
Received: from [217.108.136.188] ([217.108.136.188]:1101 "EHLO
	smtp.VirtualLogix.COM" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab0DVWvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:51:47 -0400
X-Greylist: delayed 2421 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Apr 2010 18:51:46 EDT
Date: Fri, 23 Apr 2010 00:10:58 +0200
Message-Id: <201004222210.o3MMAw1B003185@localhost.localdomain>
From: Eric Lescouet <lescouet@virtuallogix.com>
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, usbip-devel@lists.sourceforge.net
Subject: Re: [PATCH]: Fix deadlock in USBIP driver (staging), linux-2.6.34-rc5
Reply-To: Eric Lescouet <eric.lescouet@vlx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Odd, the patch has all leading tabs and spaces stripped out of it, is
> linewrapped, and the tabs are converted to spaces :(
>
> Care to try again, third time's a charm...

OK. It looked better on my box and on the list as well ...
... but let's try another client.

    Eric.

Signed-off-by: Eric Lescouet <eric@lescouet.org>
-------------

diff -Nur linux-2.6.34-rc5/drivers/staging/usbip/usbip_event.c linux-2.6.34-rc5.new/drivers/staging/usbip/usbip_event.c
--- linux-2.6.34-rc5/drivers/staging/usbip/usbip_event.c	2010-04-20 01:29:56.000000000 +0200
+++ linux-2.6.34-rc5.new/drivers/staging/usbip/usbip_event.c	2010-04-22 19:19:52.997889126 +0200
@@ -117,6 +117,9 @@
 {
 	struct usbip_task *eh = &ud->eh;
 
+	if (eh->thread == current)
+		return; /* do not wait for myself */
+
 	wait_for_completion(&eh->thread_done);
 	usbip_dbg_eh("usbip_eh has finished\n");
 }
