Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab2A0AAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:00:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab2A0AAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:00:44 -0500
Date: Thu, 26 Jan 2012 16:00:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Earl Chew <echew@ixiacom.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <adobriyan@gmail.com>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Fix seq_file mishandling of consecutive pread()
 invocations.
Message-Id: <20120126160038.b5bb63be.akpm@linux-foundation.org>
In-Reply-To: <4F1C5D01.3060403@ixiacom.com>
References: <4F166FC9.8030906@ixiacom.com>
	<4F1C5D01.3060403@ixiacom.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jan 2012 11:01:21 -0800
Earl Chew <echew@ixiacom.com> wrote:

> [ Added Maintainers; Added reference to bugzilla.kernel.org in commit log ]
> 
> Also reported in:
> 
>     https://bugzilla.kernel.org/show_bug.cgi?id=11856
> 
> The following program illustrates the problem:
> 
>     char buf[8192];
> 
>     int fd = open("/proc/self/maps", O_RDONLY);
> 
>     n = pread(fd, buf, sizeof(buf), 0);
>     printf("%d\n", n);
> 
>     /* lseek(fd, 0, SEEK_CUR); */ /* Uncomment to work around */
> 
>     n = pread(fd, buf, sizeof(buf), 0);
>     printf("%d\n", n);
> 
> The second printf() prints zero, but uncommenting the lseek()
> corrects its behaviour.

I'm stunned and confused.  That sequence of operations is the only sane
way in which to poll the contents of a procfs file.

Surely there are many applications which open a procfs file then
repeatedly read it with pread(fd, ..., 0).  How can this problem not
have been noticed in the first five minutes??
