Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab2GOX6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 19:58:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab2GOX6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 19:58:35 -0400
Date: Sun, 15 Jul 2012 19:58:31 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.5-rc6 configfs BUG_ON
Message-ID: <20120715235831.GA21952@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120711192558.GA3393@redhat.com>
 <20120715205845.GE18682@dhcp-172-17-9-228.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120715205845.GE18682@dhcp-172-17-9-228.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2012 at 01:58:46PM -0700, Joel Becker wrote:
 
 > > Call Trace:
 > >  [<ffffffff811ec74f>] d_kill+0xaf/0x120
 > >  [<ffffffff811ec8a2>] dput+0xe2/0x1d0
 > >  [<ffffffff811dfaea>] path_put+0x1a/0x30
 > >  [<ffffffff811d9705>] vfs_fstatat+0x55/0x70
 > >  [<ffffffff811d973e>] vfs_lstat+0x1e/0x20
 > >  [<ffffffff811d99ca>] sys_newlstat+0x1a/0x40
 > >  [<ffffffff81696aed>] system_call_fastpath+0x1a/0x1f
 > > Code: f6 43 40 01 75 eb 48 8b 7b 50 e8 41 4d f6 ff 48 8b 3d c2 bf 7f 01 48 89 de e8 a2 52 f6 ff 4c 89 e7 e8 1a b5 f9 ff 5b 41 5c 5d c3 <0f> 0b be 9c 00 00 00 48 c7 c7 30 a2 9e 81 e8 42 2e e1 ff eb a7 
 > > RIP  [<ffffffff812562fb>] configfs_d_iput+0x8b/0xa0
 > >  RSP <ffff88014325be08>
 > > ---[ end trace 65e130035db36f7d ]---
 > > 
 > >   58         if (sd) {
 > >   59                 BUG_ON(sd->s_dentry != dentry);
 > > 
 > 
 > Dave,
 > 	What were you doing at the time?  Is this ocfs2, dlm, target, or
 > what?
 > 
 > Joel
 > 

See  http://codemonkey.org.uk/projects/trinity/
Running that with -c newlstat should trigger it.
(load configfs module first, no further config necessary)

	Dave
