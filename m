Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1GQIwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 04:52:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41860 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753184Ab1GQIwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 04:52:21 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX1/B9SJmCbPBzeBnwPTIT8p/wV2pdXy/OPalf/Jung
	7/iAxDgwQsJ1Mp
Message-ID: <4E22A2BC.2080900@gmx.de>
Date: Sun, 17 Jul 2011 10:52:12 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Ury Stankevich <urykhy@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Fix compaction stalls due to accounting errors in
 isolated page accounting
References: <1307459225-4481-1-git-send-email-mgorman@suse.de>
In-Reply-To: <1307459225-4481-1-git-send-email-mgorman@suse.de>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there ...

> Re-verification from testers that these patches really do fix their
> problems would be appreciated. Even if hangs disappear, please confirm
> that the values for nr_isolated_anon and nr_isolated_file in *both*
> /proc/zoneinfo and /proc/vmstat are sensible (i.e. usually zero).

I applied these patches to 2.6.38.8 and it run for nearly a month
without any problems. Even Though I did not check nr_isolated_*.
As (at least) patch3 made it into 2.6.39.3 I did not apply the
others any more. And it occurred again this morning:


  sysload at 2, iowait at 80% on an idle (single core) system


$ grep nr_isolated /proc/zoneinfo /proc/vmstat
/proc/zoneinfo:    nr_isolated_anon 0
/proc/zoneinfo:    nr_isolated_file 1
/proc/zoneinfo:    nr_isolated_anon 0
/proc/zoneinfo:    nr_isolated_file 4294967295
/proc/zoneinfo:    nr_isolated_anon 0
/proc/zoneinfo:    nr_isolated_file 0
/proc/vmstat:nr_isolated_anon 0
/proc/vmstat:nr_isolated_file 0

I captured several SysRq-* logs, in case they're of interest.

Thomas
