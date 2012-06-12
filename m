Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab2FLHpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:45:45 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45976 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2FLHpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:45:44 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-4a-4fd6f3a1f063
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC PATCHSET 0/3] tools lib traceevent: Generic error handling for pevent
Date: Tue, 12 Jun 2012 16:42:36 +0900
Message-Id: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a small patch series for preparation of the die removal.
I added some error code to be used for pevent_parse_event() and
_strerror function much like the perf target does.

I don't like the name 'pevent' but since it's a part of the API
so I used it for the name.

This can eliminate a few of die() and do_warning() but will lose
some details on the error message - i.e. event name. I couldn't
think of a way that doesn't lose such info after returning from
the function. But I guess we might get the info from the context.

Patch 01 is independent and can be applied separately.

Any comments are welcome.

Thanks,
Namhyung


Namhyung Kim (3):
  tools lib traceevent: Do not link broken field arg for an old ftrace event
  tools lib traceevent: Introduce pevent_errno
  tools lib traceevent: Introduce pevent_strerror

 tools/lib/traceevent/event-parse.c |  104 ++++++++++++++++++++++++++++--------
 tools/lib/traceevent/event-parse.h |   28 +++++++++-
 2 files changed, 107 insertions(+), 25 deletions(-)

-- 
1.7.10.2

