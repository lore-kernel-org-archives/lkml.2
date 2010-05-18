Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab0ERPCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:02:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38932 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab0ERPCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:02:19 -0400
Date: Tue, 18 May 2010 16:02:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20100518150211.GG31073@ZenIV.linux.org.uk>
References: <20100518164520.7e9652b1.sfr@canb.auug.org.au>
 <m1wrv13dam.fsf@fess.ebiederm.org>
 <20100518175451.a01e314b.sfr@canb.auug.org.au>
 <m1iq6lh50h.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1iq6lh50h.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 03:35:10AM -0700, Eric W. Biederman wrote:
> Thanks.
> 
> I will cook up a proper incremental patch after I get some sleep.  Stephen
> it appears those two lines you have commented out are actually unnecessary.
> 
> We have
> deactivate_super
>   kill_sb aka sysfs_kill_sb
>     kill_anon_super
>       generic_shutdown_super
>          sb_lock
>          list_del(sb->s_instances)
>          sb_unlock
>   kfree(info)
> 
> Nothing generic stomps on s_fs_info.
> 
> Which means that if I find a superblock on sb->s_instances sb->s_fs_info
> still points to a valid sysfs_super_info.

Except that sb_lock is going away next cycle.  There are very few users left
outside of fs/super.c and I'd much prefer it to become static.
