Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964916Ab2CATGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:06:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11468 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab2CATDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:03:47 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=3agwfarryv0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZSBtEVsvCWZWRKQE_cUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120301185527.064629423@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 01 Mar 2012 13:55:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Subject: [PATCH RT 0/9][RFC] rt: Fix hotplugging and other nasties
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On both 3.0-rt and 3.2-rt I ran a stress test on CPU hotplug and they
both failed miserably. These bugs also show themselves on suspend.

After spending 5 long days debugging this, and finding lots of bugs
I have a patch series that makes the CPU hot plugging rather stable.

The first few patches fix other broken RT features that were discovered
while debugging hotplug.

Patch 7 is a rework of how RT handles taking down a CPU. There were
several corner cases that the original approach failed on, and this
rework seems to cover them now.

Patch 8 and 9 revert the rework that was done on workqueue for RT.
Yes, letting workqueues play games with THREAD_BOUND is bad, but
the fixes introduced several more races that were very hard to fix.
Every fix seemed to produce a new race, and it was a bad game of
cat and mouse running around a goose hunt whacking moles!

Since the rework of the CPU down code no longer had issues with
workqueue messing with THREAD_BOUND, reverting the patches that did
the rework of workqueues fixed the bugs that I was hitting.

Lets fix CPU hotplug today, and leave the redesign of workqueues
for another day.

Comments,

-- Steve

