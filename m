Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab2BCIhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:37:52 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46119 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab2BCIhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:37:50 -0500
MIME-Version: 1.0
Date: Fri, 3 Feb 2012 09:37:48 +0100
Message-ID: <CACKLOr26BuTh8Qr8pFHoTJoyCW9ty4-Kg-YRisXmN3=spzY6_Q@mail.gmail.com>
Subject: [dmaengine] [Q] jiffies value does not increase in dma_sync_wait()
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have a Visstrim_M10 board, based on i.MX27, and I'm developing a
v4l2 driver for deinterlacing video frames.

Whenever I start a new dma transfer I call the function
"dma_wait_for_async_tx()" which internally ends up calling
"dma_sync_wait()":

http://lxr.linux.no/#linux+v3.2.2/drivers/dma/dmaengine.c#L255

In this function, there is a "do while" loop, which checks for dma
completion, with a timeout. However, when the system is too loaded
this function enters this "do while" loop and never gets out of it,
blocking the system.

I've introduced a couple of printk() to check why this timeout is not
triggered and I've found that the value of jiffies does not increase
between loop iterations (i. e. it's like time didn't advance).

Does anyobody know what reasons could make jiffies not being updated?

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
