Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2KGK45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:56:57 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55759 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab2KGK4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:56:55 -0500
Date: Wed, 7 Nov 2012 02:53:49 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
Message-ID: <20121107105348.GA25549@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is the third RFC. As suggested by Minchan Kim, the API is much
simplified now (comparing to vmevent_fd):

- As well as Minchan, KOSAKI Motohiro didn't like the timers, so the
  timers are gone now;
- Pekka Enberg didn't like the complex attributes matching code, and so it
  is no longer there;
- Nobody liked the raw vmstat attributes, and so they were eliminated too.

But, conceptually, it is the exactly the same approach as in v2: three
discrete levels of the pressure -- low, medium and oom. The levels are
based on the reclaimer inefficiency index as proposed by Mel Gorman, but
userland does not see the raw index values. The description why I moved
away from reporting the raw 'reclaimer inefficiency index' can be found in
v2: http://lkml.org/lkml/2012/10/22/177

While the new API is very simple, it is still extensible (i.e. versioned).

As there are a lot of drastic changes in the API itself, I decided to just
add a new files along with vmevent, it is much easier to review it this
way (I can prepare a separate patch that removes vmevent files, if we care
to preserve the history through the vmevent tree).

Thanks,
Anton.

--
 Documentation/sysctl/vm.txt                |  47 +++++
 arch/x86/syscalls/syscall_64.tbl           |   1 +
 include/linux/syscalls.h                   |   2 +
 include/linux/vmpressure.h                 | 128 ++++++++++++
 kernel/sys_ni.c                            |   1 +
 kernel/sysctl.c                            |  31 +++
 mm/Kconfig                                 |  13 ++
 mm/Makefile                                |   1 +
 mm/vmpressure.c                            | 231 +++++++++++++++++++++
 mm/vmscan.c                                |   5 +
 tools/testing/vmpressure/.gitignore        |   1 +
 tools/testing/vmpressure/Makefile          |  30 +++
 tools/testing/vmpressure/vmpressure-test.c |  93 +++++++++
 13 files changed, 584 insertions(+)
