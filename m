Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1I1OrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:47:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33881 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1I1OrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:47:05 -0400
MIME-Version: 1.0
In-Reply-To: <201109281558.05289.rjw@sisk.pl>
References: <20110928145144.3d074db9aa9b6f858e0dc4fb@canb.auug.org.au>
	<CACVXFVMrPNZupCQnBMBXsSA1OH=15m9QBKhXT1Of+LghZbKn0Q@mail.gmail.com>
	<201109281558.05289.rjw@sisk.pl>
Date: Wed, 28 Sep 2011 22:47:03 +0800
Message-ID: <CACVXFVMLBHu+CY1pgQnY04S_3iLN1z5S2vPiMdN6rsW=gBdWog@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the pm tree
From: Ming Lei <ming.lei@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/9/28 Rafael J. Wysocki <rjw@sisk.pl>:
> On Wednesday, September 28, 2011, Ming Lei wrote:
>> Hi Stephen and Rafael,
>>
>> Sorry, the attachment patch can fix the build failure, which is
>> caused by unset CONFIG_RUNTIME_PM.
>
> First off, that's CONFIG_PM_RUNTIME.  Second, why do you want to build
> rpm-traces.c at all if CONFIG_PM_RUNTIME is unset?
>

Yes, you are right,  follows the correct fix:

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 56bdab5..f49405f 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -53,7 +53,9 @@ endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_TRACEPOINTS) += power-traces.o
+ifeq ($(CONFIG_PM_RUNTIME),y)
 obj-$(CONFIG_TRACEPOINTS) += rpm-traces.o
+endif
 ifeq ($(CONFIG_TRACING),y)
 obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
 endif

thanks,
--
Ming Lei
