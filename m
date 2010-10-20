Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab0JTLEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 07:04:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41806 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0JTLEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 07:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Jc7wBhG7jYJTbgMWipaUZSCRcPHCrf3hT23iMqeGxej+Owt2v4Piy0QVaY84Mosl14
         9J8bkp3OKNjrO3v2A0tIhc1gRUmi8T1DWqpDxvRTe/fXMOh5utUvgmaRJgRQvopwBWEw
         0rapVlW+i+H/JLMqa1xfiPvSi5KesIfzYbUNw=
MIME-Version: 1.0
Date: Wed, 20 Oct 2010 17:04:13 +0600
Message-ID: <AANLkTim-m3sBPV=cvdBGga=tYx5Md-thWS6V9T+2CMBT@mail.gmail.com>
Subject: [PATCH] kernel/stop_machine.c: Fix unused variable waring.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fixes the following unused variable warning.

kernel/stop_machine.c: In function ‘cpu_stopper_thread’:
kernel/stop_machine.c:265: warning: unused variable ‘ksym_buf’


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus-rc8/kernel/stop_machine.c	2010-10-20 16:48:16.000000000 +0600
+++ rakib-rc8/kernel/stop_machine.c	2010-10-20 16:48:35.000000000 +0600
@@ -262,7 +262,7 @@ repeat:
 		cpu_stop_fn_t fn = work->fn;
 		void *arg = work->arg;
 		struct cpu_stop_done *done = work->done;
-		char ksym_buf[KSYM_NAME_LEN];
+		char ksym_buf[KSYM_NAME_LEN] __maybe_unused;

 		__set_current_state(TASK_RUNNING);
