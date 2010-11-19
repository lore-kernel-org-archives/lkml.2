Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0KSOJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 09:09:58 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52210 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab0KSOJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 09:09:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=a/94o4nS9wDW/k1DWz7qbNbFXIQffpR6C6P7zL+ddu8llmNn4CZS+0l9bFyBmc99Rq
         uF7uFByfZsW3/7tnamOGjXPKPvdts9mbsflqEx43WMyYzVLKbPTACG4CaRZtOdI05/NR
         dTL0x2YYME2a+GCOr4PlAzMuNXFyrh/EAvbvU=
From: Jordi Pujol <jordipujolp@gmail.com>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Galbraith patch
Date: Fri, 19 Nov 2010 15:09:49 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-0.jpp.11-lnet-amd64; KDE/4.4.5; x86_64; ; )
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201011181628.13324.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191509.49586.jordipujolp@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

it requires a little modification,

CONFIG_SCHED_DEBUG should not be a condition to create autogroup in structure
task_group

remove 
    && defined(CONFIG_SCHED_DEBUG)
in the following conditional:

+++ linux-2.6.36/kernel/sched.c
@@ -78,6 +78,7 @@
 
 #include "sched_cpupri.h"
 #include "workqueue_sched.h"
+#include "sched_autogroup.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
@@ -268,6 +269,10 @@ struct task_group {
 	struct task_group *parent;
 	struct list_head siblings;
 	struct list_head children;
+
+#if (defined(CONFIG_SCHED_AUTOGROUP) && defined(CONFIG_SCHED_DEBUG))
+	struct autogroup *autogroup;
+#endif
 };

Kind,

Jordi Pujol

Live never ending Tale
GNU/Linux Live forever!
http://livenet.selfip.com
