Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992582Ab2KAWu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:50:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760291Ab2KAWuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:50:55 -0400
Date: Thu, 1 Nov 2012 23:50:53 +0100
From: Jan Kara <jack@suse.cz>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: enabling psacct breaks fsfreeze
Message-ID: <20121101225053.GB31937@quack.suse.cz>
References: <20121023094351.GC27919@pcnci.linuxbox.cz>
 <20121031121517.GD18424@quack.suse.cz>
 <20121031124600.GM20752@pcnci.linuxbox.cz>
 <20121101093723.GC6584@quack.suse.cz>
 <20121101111957.GD6584@quack.suse.cz>
 <20121101142325.GD20752@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101142325.GD20752@pcnci.linuxbox.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-11-12 15:23:25, Nikola Ciprich wrote:
> Nov  1 14:23:25 vmnci22 [ 1075.178123] SysRq : Show Blocked State
> Nov  1 14:23:25 vmnci22 [ 1075.180555]   task                        PC stack   pid father
> Nov  1 14:23:25 vmnci22 [ 1075.180592] fsfreeze      D 0000000000000000     0  4215   4195 0x00000000
> Nov  1 14:23:25 vmnci22 [ 1075.180599]  ffff8800090b9b28 0000000000000046 0000000000000000 ffffffff00000000
> Nov  1 14:23:25 vmnci22 [ 1075.180606]  0000000000013780 ffff8800090b9fd8 ffff88000f716170 ffff88000f715e80
> Nov  1 14:23:25 vmnci22 [ 1075.180612]  ffff88000f715dc0 ffffffff81566080 ffff88000f716170 000000010002f405
> Nov  1 14:23:25 vmnci22 [ 1075.180619] Call Trace:
> Nov  1 14:23:25 vmnci22 [ 1075.180693]  [<ffffffff810e2dbb>] __generic_file_aio_write+0xbb/0x420
> Nov  1 14:23:25 vmnci22 [ 1075.180729]  [<ffffffff81079290>] ? autoremove_wake_function+0x0/0x40
> Nov  1 14:23:25 vmnci22 [ 1075.180736]  [<ffffffff810e317f>] generic_file_aio_write+0x5f/0xc0
  Thanks. So the system isn't really deadlocked. It's just that fsfreeze
command hangs, isn't it? OK, I understand that it's kind of incovenient
situation because every command will hang like this when the filesystem is
frozen.

Now I only have to come up with a way to improve this... It isn't quite
simple - to properly protect against freezing be have to communicate down
into generic_file_aio_write() that we want to bail out if filesystem is
frozen instead of waiting.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
