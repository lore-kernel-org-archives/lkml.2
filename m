Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab2ITQo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 12:44:56 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34466 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2ITQoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 12:44:55 -0400
Date: Thu, 20 Sep 2012 09:44:48 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-audit@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/10] vfs: define getname_info struct and have
 getname() return it
Message-ID: <20120920164448.GA19073@ghostprotocols.net>
References: <1348150999-13028-1-git-send-email-jlayton@redhat.com>
 <1348150999-13028-5-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348150999-13028-5-git-send-email-jlayton@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 20, 2012 at 10:23:13AM -0400, Jeff Layton escreveu:
> getname() is intended to copy pathname strings from userspace into a
> kernel buffer. The result is just a string in kernel space. It would
> however be quite helpful to be able to attach some ancillary info to
> the string.

Tried with:

[acme@mica linux]$ git remote add viro git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal.git
[acme@mica linux]$ git checkout -b getname-signal-git viro/experimental-kernel_thread

[acme@mica linux]$ grep Subject /wb/getname/4.patch 
Subject: [PATCH v2 04/10] vfs: define getname_info struct and have getname()
[acme@mica linux]$

[acme@mica linux]$ grep Subject /wb/getname/[1-3].patch 
/wb/getname/1.patch:Subject: [PATCH v2 01/10] vfs: allocate page instead of names_cache buffer in
/wb/getname/2.patch:Subject: [PATCH v2 02/10] vfs: make dir_name arg to do_mount a const char *
/wb/getname/3.patch:Subject: [PATCH v2 03/10] acct: constify the name arg to acct_on
[acme@mica linux]$ git log --oneline | head -3
9e7ab47 acct: constify the name arg to acct_on
2c1cd21 vfs: make dir_name arg to do_mount a const char *
99080c0 vfs: allocate page instead of names_cache buffer in mount_block_root
[acme@mica linux]$ 

git am works for the first 3, then fails for the fourth, using patch I get:

[acme@mica linux]$ patch -p1 < /wb/getname/4.patch 
<SNIP successfull part>
patching file fs/namei.c
Hunk #3 succeeded at 2124 (offset 4 lines).
Hunk #4 succeeded at 2144 (offset 4 lines).
Hunk #5 succeeded at 3070 (offset 4 lines).
Hunk #6 succeeded at 3279 (offset 4 lines).
Hunk #7 succeeded at 3374 (offset 4 lines).
Hunk #8 succeeded at 3465 (offset 4 lines).
Hunk #9 succeeded at 3478 (offset 4 lines).
Hunk #10 succeeded at 3760 (offset 4 lines).
Hunk #11 succeeded at 3998 (offset 4 lines).
patching file fs/namespace.c
patching file fs/open.c
patching file fs/quota/quota.c
patching file include/linux/audit.h
Hunk #1 succeeded at 451 with fuzz 2 (offset -8 lines).
Hunk #2 FAILED at 469.
Hunk #3 succeeded at 495 (offset -10 lines).
1 out of 3 hunks FAILED -- saving rejects to file include/linux/audit.h.rej
patching file include/linux/fs.h
patching file ipc/mqueue.c
Hunk #3 FAILED at 805.
Hunk #4 FAILED at 825.
2 out of 6 hunks FAILED -- saving rejects to file ipc/mqueue.c.rej
patching file kernel/acct.c
patching file kernel/auditsc.c
Hunk #1 FAILED at 103.
Hunk #2 succeeded at 1006 (offset 2 lines).
Hunk #3 succeeded at 1019 (offset 2 lines).
Hunk #4 succeeded at 1531 (offset 2 lines).
Hunk #5 succeeded at 1546 (offset 2 lines).
Hunk #7 FAILED at 2048.
Hunk #11 FAILED at 2166.
Hunk #12 FAILED at 2189.
Hunk #13 FAILED at 2230.
Hunk #14 FAILED at 2243.
Hunk #15 FAILED at 2277.
7 out of 15 hunks FAILED -- saving rejects to file kernel/auditsc.c.rej
patching file mm/swapfile.c
[acme@mica linux]$ 

