Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3ADIjF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 03:39:05 -0500
Received: from mail-ye0-f176.google.com ([209.85.213.176]:40381 "EHLO
	mail-ye0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab3ADIjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 03:39:04 -0500
Date: Fri, 4 Jan 2013 00:27:52 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 0/2] Mempressure cgroup
Message-ID: <20130104082751.GA22227@lizard.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is another round of the mempressure cgroup. This time I dared to
remove the RFC tag. :)

In this revision:

- Addressed most of Kirill Shutemov's comments. I didn't bother
  implementing per-level lists, though. It would needlessly complicate the
  logic, and the gain would be only visible with lots of watchers (which
  we don't have for our use-cases). But it is always an option to add the
  feature;

- I've split the pach into two: 'shrinker' and 'levels' parts. While the
  full-fledged userland shrinker is an interesting idea, we don't have any
  users ready for it, so I won't advocate for it too much.

  And since at least Kirill has some concerns about it, I don't want the
  shrinker to block the pressure levels.

  So, these are now separate. At some point, I'd like to both of them
  merged, but if anything, let's discuss them separately;

- Rebased onto v3.8-rc2.

RFC v2 (http://lkml.org/lkml/2012/12/10/128):

 - Added documentation, describes APIs and the purpose;
 - Implemented shrinker interface, this is based on Andrew's idea and
   supersedes my "balance" level idea;
 - The shrinker interface comes with a stress-test utility, that is what
   Andrew was also asking for. A simple app that we can run and see if the
   thing works as expected;
 - Added reclaimer's target_mem_cgroup handling;
 - As promised, added support for multiple listeners, and fixed some other
   comments on the previous RFC.

RFC v1 (http://lkml.org/lkml/2012/11/28/109)

--
 Documentation/cgroups/mempressure.txt    |  97 +++++
 Documentation/cgroups/mempressure_test.c | 213 ++++++++++
 include/linux/cgroup_subsys.h            |   6 +
 include/linux/vmstat.h                   |  11 +
 init/Kconfig                             |  13 +
 mm/Makefile                              |   1 +
 mm/mempressure.c                         | 487 +++++++++++++++++++++++
 mm/vmscan.c                              |   4 +
 8 files changed, 832 insertions(+)
