Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2DPMzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 08:55:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab2DPMzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 08:55:10 -0400
Date: Mon, 16 Apr 2012 08:54:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, ctalbott@google.com, rni@google.com,
        andrea@betterlinux.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, lsf@lists.linux-foundation.org,
        linux-mm@kvack.org, jmoyer@redhat.com, lizefan@huawei.com,
        cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [Lsf] [RFC] writeback and cgroup
Message-ID: <20120416125432.GB12776@redhat.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404145134.GC12676@redhat.com>
 <20120407080027.GA2584@quack.suse.cz>
 <20120410180653.GJ21801@redhat.com>
 <20120410210505.GE4936@quack.suse.cz>
 <20120410212041.GP21801@redhat.com>
 <20120410222425.GF4936@quack.suse.cz>
 <20120411154005.GD16692@redhat.com>
 <1334406314.2528.90.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334406314.2528.90.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 02:25:14PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-04-11 at 11:40 -0400, Vivek Goyal wrote:
> > 
> > Ok, that's good to know. How would we configure this special bdi? I am
> > assuming there is no backing device visible in /sys/block/<device>/queue/?
> > Same is true for network file systems. 
> 
> root@twins:/usr/src/linux-2.6# awk '/nfs/ {print $3}' /proc/self/mountinfo | while read bdi ; do ls -la /sys/class/bdi/${bdi}/ ; done
> ls: cannot access /sys/class/bdi/0:20/: No such file or directory
> total 0
> drwxr-xr-x  3 root root    0 2012-03-27 23:18 .
> drwxr-xr-x 35 root root    0 2012-03-27 23:02 ..
> -rw-r--r--  1 root root 4096 2012-04-14 14:22 max_ratio
> -rw-r--r--  1 root root 4096 2012-04-14 14:22 min_ratio
> drwxr-xr-x  2 root root    0 2012-04-14 14:22 power
> -rw-r--r--  1 root root 4096 2012-04-14 14:22 read_ahead_kb
> lrwxrwxrwx  1 root root    0 2012-03-27 23:18 subsystem -> ../../../../class/bdi
> -rw-r--r--  1 root root 4096 2012-03-27 23:18 uevent

Ok, got it. So /proc/self/mountinfo has the information about st_dev and
one can use that to reach to associated bdi. Thanks Peter.

Vivek
