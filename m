Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1DNBVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 21:21:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:31431 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1DNBV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 21:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oB35Vo4MdV9TBmCm0JEvioWpBwexHi8jTLPM8HQvF6g6LMFVxpxt2jilmJazK3vt8U
         ctgbMSCGIF9YRsXE7UsA==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Rik van Riel <riel@redhat.com>, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 0/2] sched: Avoid frequent cross taskgroup switches -v2
Date: Wed, 13 Apr 2011 18:21:08 -0700
Message-Id: <1302744070-30079-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <AANLkTi=ao5dci3gb=+UmegZx_ag_X6gAFZ5mBb+8=9hR@mail.gmail.com>
References: <AANLkTi=ao5dci3gb=+UmegZx_ag_X6gAFZ5mBb+8=9hR@mail.gmail.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As I did not hear any other comments on v1, I am assuming that the
above mentioned case of giving buddy privilege to a SCHED_IDLE task
from one cgroup when there is a non SCHED_IDLE task in other cgroup
is not an important case to handle and keeping this change simpler is better.

So, I am going with Paul's suggestion of sticking with original change,
with some cleanups to handle the frequent CR3 switches problem.

Here is the v2 version of the change, split into two patches.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>

