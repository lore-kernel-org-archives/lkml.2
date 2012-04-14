Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab2DNMZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 08:25:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:59909 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab2DNMZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 08:25:28 -0400
Message-ID: <1334406314.2528.90.camel@twins>
Subject: Re: [Lsf] [RFC] writeback and cgroup
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Kara <jack@suse.cz>, ctalbott@google.com, rni@google.com,
        andrea@betterlinux.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, lsf@lists.linux-foundation.org,
        linux-mm@kvack.org, jmoyer@redhat.com, lizefan@huawei.com,
        cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Sat, 14 Apr 2012 14:25:14 +0200
In-Reply-To: <20120411154005.GD16692@redhat.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
	 <20120404145134.GC12676@redhat.com> <20120407080027.GA2584@quack.suse.cz>
	 <20120410180653.GJ21801@redhat.com> <20120410210505.GE4936@quack.suse.cz>
	 <20120410212041.GP21801@redhat.com> <20120410222425.GF4936@quack.suse.cz>
	 <20120411154005.GD16692@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 11:40 -0400, Vivek Goyal wrote:
> 
> Ok, that's good to know. How would we configure this special bdi? I am
> assuming there is no backing device visible in /sys/block/<device>/queue/?
> Same is true for network file systems. 

root@twins:/usr/src/linux-2.6# awk '/nfs/ {print $3}' /proc/self/mountinfo | while read bdi ; do ls -la /sys/class/bdi/${bdi}/ ; done
ls: cannot access /sys/class/bdi/0:20/: No such file or directory
total 0
drwxr-xr-x  3 root root    0 2012-03-27 23:18 .
drwxr-xr-x 35 root root    0 2012-03-27 23:02 ..
-rw-r--r--  1 root root 4096 2012-04-14 14:22 max_ratio
-rw-r--r--  1 root root 4096 2012-04-14 14:22 min_ratio
drwxr-xr-x  2 root root    0 2012-04-14 14:22 power
-rw-r--r--  1 root root 4096 2012-04-14 14:22 read_ahead_kb
lrwxrwxrwx  1 root root    0 2012-03-27 23:18 subsystem -> ../../../../class/bdi
-rw-r--r--  1 root root 4096 2012-03-27 23:18 uevent

