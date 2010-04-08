Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab0DHKN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 06:13:27 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:55666 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758506Ab0DHKNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 06:13:24 -0400
From: Denys Fedorysychenko <nuclearcat@nuclearcat.com>
To: Jan Kara <jack@suse.cz>
Subject: Re: endless sync on bdi_sched_wait()? 2.6.33.1
Date: Thu, 8 Apr 2010 13:12:05 +0300
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-rt21-home1; KDE/4.3.5; x86_64; ; )
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <201003311907.31342.nuclearcat@nuclearcat.com> <20100408092850.GA20488@quack.suse.cz>
In-Reply-To: <20100408092850.GA20488@quack.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004081312.06018.nuclearcat@nuclearcat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > SUPERPROXY ~ # cat /proc/1753/stack
> > [<c019a93c>] bdi_sched_wait+0x8/0xc
> > [<c019a807>] wait_on_bit+0x20/0x2c
> > [<c019a9af>] sync_inodes_sb+0x6f/0x10a
> > [<c019dd53>] __sync_filesystem+0x28/0x49
> > [<c019ddf3>] sync_filesystems+0x7f/0xc0
> > [<c019de7a>] sys_sync+0x1b/0x2d
> > [<c02f7a25>] syscall_call+0x7/0xb
> > [<ffffffff>] 0xffffffff
> 
>   Hmm, I guess you are observing the problem reported in
> https://bugzilla.kernel.org/show_bug.cgi?id=14830
>   There seem to be several issues in the per-bdi writeback code that
> cause sync on a busy filesystem to last almost forever. To that bug are
> attached two patches that fix two issues but apparently it's not all.
> I'm still looking into it...
> 
> 								Honza
> 
Hi

Thanks for info, i will try to test them as soon as i finish with my current 
issues, and kernel will reach at least rc5, because servers where i test - 
loaded and production.
