Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0HSVHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:07:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354Ab0HSVHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:07:50 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Thu, 19 Aug 2010 23:07:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008192224.12309.agruen@suse.de> <1282250565.21419.1821.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282250565.21419.1821.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008192307.32526.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 August 2010 22:42:45 Eric Paris wrote:
> The extra events are plainly the new events that inotify doesn't
> support: namely permissions events.  You ask for and received extra
> events....

How can it make sense that inotify suddenly starts seeing events it does not
support?

> I can't reproduce it. You must have some other testing methodology.....

Apparently.  Here is a trace if what I'm getting through inotify (the inotify
events were dumped with gdb, the rest is from strace):

inotify_init()                          = 3
inotify_add_watch(3, "d", IN_ACCESS|IN_MODIFY|IN_ATTRIB|IN_CLOSE_WRITE|IN_CLOSE_NOWRITE|IN_OPEN|IN_MOVED_FROM|IN_MOVED_TO|IN_CREATE|
IN_DELETE|IN_DELETE_SELF|IN_MOVE_SELF) = 1
read(3, "\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0 \0\0@\0\0\0\0\0\0\0\0", 4210688) = 32

	=> {wd = 1, mask = 0, cookie = 0, len = 0, name = ...}
	=> {wd = 1, mask = 1073741856, cookie = 0, len = 0, name = ...}

read(3, "\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\20\0\0@\0\0\0\0\0\0\0\0", 4210688) = 32

	=> {wd = 1, mask = 0, cookie = 0, len = 0, name = ...}
	=> {wd = 1, mask = 1073741840, cookie = 0, len = 0, name = ...}

read(3, 0x7fff56db15e0, 4210688)        = -1 EINTR (Interrupted system call)


Andreas
