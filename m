Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab0JXTu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 15:50:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33411 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914Ab0JXTuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 15:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=lNOcErfeECj1TCAQRVswLA7xKamPbsKfvQ8OPr8QZ403H+cZRRlRhzyA+CvqMOINNa
         zvyWxPJ4ARgoLU85c9gPXFy0VhKnThQt6gLthiYG0dZIEZz8zVQtPTAqrIzQtPi1yZkk
         dHLYN5gw4HNcU79tkmNMVAu5D4+6sE1eBJXhY=
Date: Sun, 24 Oct 2010 21:50:42 +0200
From: Dan Carpenter <error27@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] perf: off by one in perf_swevent_init()
Message-ID: <20101024195041.GT5985@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_swevent_enabled[] array has PERF_COUNT_SW_MAX elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f309e80..c45396d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4687,7 +4687,7 @@ static int perf_swevent_init(struct perf_event *event)
 		break;
 	}
 
-	if (event_id > PERF_COUNT_SW_MAX)
+	if (event_id >= PERF_COUNT_SW_MAX)
 		return -ENOENT;
 
 	if (!event->parent) {
