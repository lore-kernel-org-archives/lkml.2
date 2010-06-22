Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab0FVIyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:54:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36233 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab0FVIyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:54:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 22 Jun 2010 17:49:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Edward Allcutt <edward@allcutt.me.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
       Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] fs: limit maximum concurrent coredumps
Message-Id: <20100622174906.ddf7d298.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100621184116.92f85696.akpm@linux-foundation.org>
References: <1277164737-30055-1-git-send-email-edward@allcutt.me.uk>
	<20100622012303.BD72E402AD@magilla.sf.frob.com>
	<20100621184116.92f85696.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 18:41:16 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 21 Jun 2010 18:23:03 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> > That won't make your crashers each complete quickly, but it will prevent
> > the thrashing.  Instead of some crashers suddenly not producing dumps at
> > all, they'll just all queue up waiting to finish crashing but not using any
> > CPU or IO resources.  That way you don't lose any core dumps unless you
> > want to start SIGKILL'ing things (which oom_kill might do if need be),
> > you just don't die in flames trying to do nothing but dump cores.
> 
> A global knob is a bit old-school.  Perhaps it should be a per-memcg
> knob or something.
> 

Hmm, in my desktop, it seems coredump in a group is charged against
root cgroup. (not against the group it belongs to.)
This seems strange.....I've chased why...for 2 hours. I noticed 

==
[root@bluextal kamezawa]# cat /proc/sys/kernel/core_pattern
|/usr/libexec/abrt-hook-ccpp /var/cache/abrt %p %s %u %c
==
This is fedora-12.

Then, for recent distros, doing "coredump" with some limited resource may
be a job of abrt program. It can make use of I/O cgroup + direct I/O.

If a kernel help is necesary, this helper function should work in
the caller's cgroup, maybe.

Regards,
-Kame

