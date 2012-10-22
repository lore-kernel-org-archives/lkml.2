Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2JVNLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab2JVNLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:11:48 -0400
Date: Mon, 22 Oct 2012 15:11:42 +0200
From: Andrew Jones <drjones@redhat.com>
To: namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: perf: header: Regression
Message-ID: <20121022131141.GA11455@turtle.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The patch series that contains 7e94cfcc9d20 regresses the
header output. Below is a diff of info from before and
after the series

58,64c58,59
< # node1 meminfo  : total = 16777216 kB, free = 15712440 kB
< # node1 cpu list : 2,6,10,14,18,22,26,30
< # node2 meminfo  : total = 16777216 kB, free = 16299132 kB
< # node2 cpu list : 1,5,9,13,17,21,25,29
< # node3 meminfo  : total = 16777216 kB, free = 16217192 kB
< # node3 cpu list : 3,7,11,15,19,23,27,31
< # pmu mappings: cpu = 4, software = 1, tracepoint = 2, uncore_bbox_0 =
15, uncore_bbox_1 = 16, uncore_cbox_0 = 7, uncore_cbox_1 = 8,
uncore_cbox_2 = 9, uncore_cbox_3 = 10, uncore_cbox_4 = 11, uncore_cbox_5 =
12, uncore_cbox_6 = 13, uncore_cbox_7 = 14, uncore_mbox_0 = 19,
uncore_mbox_1 = 20, uncore_rbox_0 = 21, uncore_rbox_1 = 22, uncore_sbox_0
= 17, uncore_sbox_1 = 18, breakpoint = 5, uncore_ubox = 6, uncore_wbox =
23
---
> # numa topology : not available
> # pmu mappings: cpu = 4, software = 1, tracepoint = 2, uncore_bbox_0 =
15, uncore_bbox_1 = 16, uncore_cbox_0 = 7, uncore_cbox_1 = 8,
uncore_cbox_2 = 9, uncore_cbox_3 = 10, uncore_cbox_4 = 11, uncore_cbox_5 =
12, uncore_cbox_6 = 13, uncore_cbox_7 = 14, uncore_mbox_0 = 19# pmu
mappings: unable to read

As can be seen in the diff, before the series we had complete
numa info and pmu mappings info. After we get 

"# numa topology : not available" and "# pmu
mappings: unable to read"

Drew
