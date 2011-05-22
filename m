Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1EVCVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 22:21:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57651 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab1EVCVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 22:21:31 -0400
Date: Sun, 22 May 2011 03:21:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, npiggin@kernel.dk,
        tim.c.chen@intel.com
Subject: Re: [PATCH] VFS: Add VFS event counter infrastructure
Message-ID: <20110522022126.GJ19987@ZenIV.linux.org.uk>
References: <1305332052-15633-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305332052-15633-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 05:14:12PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The recently discovered problem with RCU walks not working for absolute path
> motivated me to add some counters for these events to the VFS. Networking
> and VM has had such counters for a long time and they were always useful
> to diagnose performance problems. An advantage of counters over tracepoints
> is that they are always collected and are low enough overhead that
> they can be always enabled (unlike tracing)
> 
> This patch implements a simple per CPU counter framework for the VFS.
> The counters are per CPU and are very little overhead. The counters
> are output in debugfs (/sys/kernel/fs/vfsstat)

WTF?  Since when had debugfs become mandatory?

> +	fs = debugfs_create_dir("fs", NULL);
> +	if (fs)
> +		debugfs_create_file("vfsstat", 0444, fs, NULL, &vfsstat_fops);
> +	return 0;

Note that if that FPOS is configured away debugfs_create_dir() does _NOT_
return NULL - you get ERR_PTR(-ENODEV).
