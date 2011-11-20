Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1KSTGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 14:06:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab1KSTGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 14:06:14 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC,PATCHv2] perf tool: Refactoring IO data files code
Date: Sat, 19 Nov 2011 21:03:48 -0500
Message-Id: <1321754633-11489-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
References: <1321624005-6889-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

based on following discussion:
http://marc.info/?l=linux-kernel&m=131731212425421&w=2
http://marc.info/?l=linux-kernel&m=131736842010972&w=2

I made some changes to have event memory mapping and input/output
data code in one place. The reason was to make the change for
multiple event data files at least possible ;)

This patchset is marked as RFC since it's quite big change
and I expect some better design might come up.

However, patches 1 and 2 are not big deal, since they are
just small (not so related) changes.

Patches 3-4 are the main change of the patchset.

1/5 perf tool: Fix session host_nachine retrieval
2/5 perf tool: Initialize events IDs in a single function
3/5 perf tool: Introducing perf_mmap object
4/5 perf tool: Introducing perf_data object
5/5 perf tool: Putting mmap support to perf_data object

I did some overall testing of all the changed command,
and so far so good. Just hit issue with 'diff' command,
but this one seems not to work even without my changes.

Also the current perf python binsing code is broken
wit missing dependencies so I could not test my
changes there.

v2 changes:
  - 3/5 kept the perf_evlist__mmap_read function as a wrapper
    around perf_mmap__read
  - 4/5 removed unlink call from file_backup, because it's not
    needed when followed with rename

thanks for comments,
jirka
