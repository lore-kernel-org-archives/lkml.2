Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2KTAMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:12:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab2KTAMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:12:51 -0500
Date: Mon, 19 Nov 2012 16:12:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kerolasa@gmail.com
Cc: Sami Kerola <kerolasa@iki.fi>, Al Viro <viro@zeniv.linux.org.uk>,
        Doug Ledford <dledford@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>
Subject: Re: ipc: object information data in proc and sysfs
Message-Id: <20121119161250.ae0b25ff.akpm@linux-foundation.org>
In-Reply-To: <CAG27Bk1q5t590bvGg7Ka+2M-yWEMk_58sZsOxDKx-1XNn8mHww@mail.gmail.com>
References: <CAG27Bk1q5t590bvGg7Ka+2M-yWEMk_58sZsOxDKx-1XNn8mHww@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2012 12:31:08 +0000
Sami Kerola <kerolasa@iki.fi> wrote:

> Hello,
> 
> While back I started to look how to get util-linux ipcs(1) tool to
> read values from /proc instead of using IPC multiplex functions.  Most
> of the data ipcs(1) is interested is available in /proc, but there are
> few exceptions, such as
> 
> msgctl q_qbytes
> semctl getval
> semctl sempid
> semctl semncnt
> semctl semzcnt
> 
> The simplest thing to do would be to add values in /proc/sysvipc/msg
> and /proc/sysvipc/sem as additional fields, but that does not seem
> right, as it would result to ABI change.
> 
> More effort requiring change would be to add information in new sysfs
> paths.  The IPC facilities are using id's which could be used as
> placeholder directories for the data needed.  Something like
> 
> /proc/sys/kernel/ipc/{m,s,q}/id/info
>                  ^^^^^^^^^^^^^^^^^^^
> 
> That sort of structure would allow future extensions IPC data without
> much pain.  I also assume that subdirectories could allow a little
> more precise controls, and perhaps some selected values might be made
> writable in future.  If nothing else at least expressing in sensible
> format semaphore lock wait queues could make debugging tools, such as
> lslocks(8), more useful.
> 
> I could give a try this change, but not without hearing the concept
> makes sense and could be considered part of upstream kernel (assuming
> my coding meets the usual quality criteria).
> 
> Any thoughts, comments, recommendations?

Where's the benefit in switching ipcs over to using /proc?

procfs reads are probably slower than the syscalls?
