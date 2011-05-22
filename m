Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1EVCYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 22:24:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42333 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab1EVCYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 22:24:48 -0400
Date: Sun, 22 May 2011 04:24:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        npiggin@kernel.dk, tim.c.chen@intel.com
Subject: Re: [PATCH] VFS: Add VFS event counter infrastructure
Message-ID: <20110522022445.GU12317@one.firstfloor.org>
References: <1305332052-15633-1-git-send-email-andi@firstfloor.org> <20110522022126.GJ19987@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110522022126.GJ19987@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Any comments on where I placed the counters?

> > This patch implements a simple per CPU counter framework for the VFS.
> > The counters are per CPU and are very little overhead. The counters
> > are output in debugfs (/sys/kernel/fs/vfsstat)
> 
> WTF?  Since when had debugfs become mandatory?

What do you mean? It's not mandatory of course.

I had it originally in /proc, but then moved it to debugfs.

> 
> > +	fs = debugfs_create_dir("fs", NULL);
> > +	if (fs)
> > +		debugfs_create_file("vfsstat", 0444, fs, NULL, &vfsstat_fops);
> > +	return 0;
> 
> Note that if that FPOS is configured away debugfs_create_dir() does _NOT_
> return NULL - you get ERR_PTR(-ENODEV).

That's fine because debugfs_create_file is a noop then too
and fs isn't used anywhere else.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
