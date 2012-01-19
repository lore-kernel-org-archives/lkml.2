Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab2ASCL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 21:11:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54877 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab2ASCL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 21:11:26 -0500
Message-ID: <4F177C67.6070907@cn.fujitsu.com>
Date: Thu, 19 Jan 2012 10:13:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [RFC] splitting cgroup.c
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-19 10:10:14,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-19 10:10:15,
	Serialize complete at 2012-01-19 10:10:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on cgroup xattr, it appeared to me it's better to
create a cgroup_xattr.c instead of stuffing things into cgroup.c.

Then I took a look at how big it is.

    $ ls -l -S kernel/*.c
    -rw-rw-r--  1 lizf lizf 142717 Jan 18 10:15 cgroup.c
    -rw-rw-r--  1 lizf lizf 106498 Jan 18 10:15 workqueue.c
    -rw-rw-r--  1 lizf lizf 105206 Jan 18 10:15 lockdep.c
    -rw-rw-r--  1 lizf lizf  91321 Jan 18 10:16 module.c
    
    $ wc -l kernel/*.c | sort -n -r
      90397 total
       5289 cgroup.c
       4206 lockdep.c
       3840 workqueue.c
       3507 module.c

So I think for the sake of readability and maintainability, we'd
better split cgroup.c into smaller pieces:

- event_control.c
- css_id.c
- debug.c
- proc.c
- super.c
...
- cgroup.c

We may add xattr.c and release_agency.c as I'm working on them.

Any objection?
