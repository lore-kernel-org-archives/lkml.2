Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab1GSLYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 07:24:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35940 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751199Ab1GSLYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 07:24:39 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX18Ku9IYmKMKX5lbPDPVUKnfPr3vUBLAfqJzWmpF2/
	at6pA13TbG80Mb
Message-ID: <4E25696E.1060106@gmx.de>
Date: Tue, 19 Jul 2011 13:24:30 +0200
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
References: <1307459225-4481-1-git-send-email-mgorman@suse.de> <4E22A2BC.2080900@gmx.de> <20110719091647.GE5349@suse.de>
In-Reply-To: <20110719091647.GE5349@suse.de>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I assume you mean it occured again on 2.6.39.3 and so have submitted
> them to -stable for 2.6.39.x. You're cc'd so you should hear when or if
> they get picked up.

Yes, that's, what I meant:

$ uname -a
Linux pearl 2.6.39.3 #14 PREEMPT Thu Jul 14 17:41:20 CEST 2011 i686
Intel(R) Pentium(R) M processor 1700MHz GenuineIntel GNU/Linux

$ grep nr_isolated /proc/zoneinfo /proc/vmstat
/proc/zoneinfo:    nr_isolated_anon 25
/proc/zoneinfo:    nr_isolated_file 7
/proc/zoneinfo:    nr_isolated_anon 4294967271
/proc/zoneinfo:    nr_isolated_file 4294967289
/proc/zoneinfo:    nr_isolated_anon 0
/proc/zoneinfo:    nr_isolated_file 0
/proc/vmstat:nr_isolated_anon 0
/proc/vmstat:nr_isolated_file 0

$ top  # only headlines
top - 13:23:27 up 2 days,  2:52,  6 users,  load average: 2.30, 2.09, 1.69
Tasks: 132 total,   3 running, 129 sleeping,   0 stopped,   0 zombie
Cpu(s): 16.9%us,  5.6%sy,  0.0%ni,  0.0%id, 77.4%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   1551416k total,  1449088k used,   102328k free,    80736k buffers
Swap:  4120660k total,    48776k used,  4071884k free,   721312k cached

Thomas
