Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0CYKsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:48:53 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:54190 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab0CYKsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:48:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=XbEmH8EFRxbmXBHaZ7bRMm7Z0MtopQ0hGAykzkkJvC0BjKtErGrA5DXmREZ24QvQE/
         FUvk7FLnTib7jdxTo0dXwkC7Ya9A1KAO/IcwewQz6woMlccsTKvTlabLcVEjzPjn8LHk
         N/K/RrjMJUiAyI1H/sh58eEGKJJBkd6BwGHOY=
MIME-Version: 1.0
Date: Thu, 25 Mar 2010 11:48:49 +0100
Message-ID: <c4e36d111003250348q678eb2e6w4f3e8133e7fd6e58@mail.gmail.com>
Subject: INFO: suspicious rcu_dereference_check()
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-nfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've enabled rcu correctness for my  todays 2.6.34-rc2 kernel.

I'm getting this INFO: from my kvm guest (which uses host's nfs
exported directory.)
This

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
fs/nfs/delegation.c:348 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
2 locks held by rm/1820:
 #0:  (&sb->s_type->i_mutex_key#13/1){+.+.+.}, at:
[<ffffffff81138e1b>] do_unlinkat+0x9b/0x1c0
 #1:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81136a76>]
vfs_unlink+0x56/0xf0

stack backtrace:
Pid: 1820, comm: rm Not tainted 2.6.34-rc2-00186-ge79a302 #60
Call Trace:
 [<ffffffff810819fb>] lockdep_rcu_dereference+0xbb/0xc0
 [<ffffffffa0228351>] nfs_inode_return_delegation+0x101/0x110 [nfs]
 [<ffffffffa01fd58d>] nfs_unlink+0xad/0x2a0 [nfs]
 [<ffffffff81136aba>] vfs_unlink+0x9a/0xf0
 [<ffffffff81148365>] ? mnt_want_write+0x65/0xb0
 [<ffffffff81138f03>] do_unlinkat+0x183/0x1c0
 [<ffffffff8142b66d>] ? retint_swapgs+0xe/0x13
 [<ffffffff81083985>] ? trace_hardirqs_on_caller+0x155/0x1a0
 [<ffffffff8142a232>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff811390a2>] sys_unlinkat+0x22/0x40
 [<ffffffff81031dc8>] sysenter_dispatch+0x7/0x2c


Zdenek
