Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0KWNB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:01:29 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62149 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab0KWNB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:01:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:user-agent:date:message-id:mime-version
         :content-type;
        b=hAMxj2kfzKfD2t6NRHVnMA0gJ1iSHl8bLUmYPKvXF4zqzUI6w2NcO6nuslflamPBpR
         u2WjS+LiiVXU+4311JtHvn0iV6CMjGXHXnDVe0l9qNsg/J/d4M1D3lX5p0UjpFfrL56Q
         Q/bcIlZ1wShcyiPqjecppK5gH3mFPkK3ijxyc=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: How about limiting refresh ioctl to sampling events ?
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Tue, 23 Nov 2010 14:01:23 +0100
Message-ID: <m3zkt05h3w.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

I'm looking at the perf event stuff and wondering if
perf_event_refresh() should be limited to sampling events.

Does the following make sense ?

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3b105e0..1a90a6c 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1072,7 +1072,7 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
 	/*
 	 * not supported on inherited events
 	 */
-	if (event->attr.inherit)
+	if (event->attr.inherit || !event->attr.sample_period)
 		return -EINVAL;
 
 	atomic_add(refresh, &event->event_limit);

Thanks
-- 
		Franck
