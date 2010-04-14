Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0DNNAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:00:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab0DNNAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:00:20 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] tracing: lost events changes
Date: Wed, 14 Apr 2010 15:00:03 +0200
Message-Id: <1271250005-11434-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I noticed LOST EVENTS messages in the iterator "trace" file.
According to the comment from commit bc21b478 this won't work.

<comment>
    Note, it does not work with the iterator "trace" file, since it requires
    the use of consuming the page from the ring buffer to determine how many
    events were lost, which the iterator does not do.
</comment>

I'm not sure the attached fix (2/2) is on the right place,
but stops the LOST EVENTS display for iterator "trace" file.

I also added option to control the LOST EVENTS display (1/2) if needed.

attached patches:
- 1/2 - adding lost-events option
- 2/2 - supress lost events message for iterator "trace"


wbr,
jirka
---
 kernel/trace/trace.c |   24 ++++++++++++++----------
 kernel/trace/trace.h |    1 +
 2 files changed, 15 insertions(+), 10 deletions(-)
