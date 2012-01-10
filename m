Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab2AJBoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 20:44:38 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:29739 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283Ab2AJBog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 20:44:36 -0500
Date: Mon, 9 Jan 2012 20:44:32 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs/mmap lockdep report from 3.2
Message-ID: <20120110014432.GC26546@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120110010331.GA15942@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120110010331.GA15942@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F0B9803.0016,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 08:03:32PM -0500, Dave Jones wrote:
> Just hit this with Linus' tree as of 37cfc3f67db9f2d907f6bfcfae590cdbbef623e8
> 
> 	Dave
> 
> [  130.932837] ======================================================
> [  130.933032] [ INFO: possible circular locking dependency detected ]
> [  130.933032] 3.2.0+ #19 Not tainted
> [  130.933032] -------------------------------------------------------
> [  130.933032] firefox/1630 is trying to acquire lock:
> [  130.933032]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffffa011fd5b>] btrfs_page_mkwrite+0x5b/0x310 [btrfs]
> [  130.933032] 
> [  130.933032] but task is already holding lock:
> [  130.933032]  (&mm->mmap_sem){++++++}, at: [<ffffffff816a38c8>] do_page_fault+0xe8/0x5d0
> [  130.933032] 
> [  130.933032] which lock already depends on the new lock.

>From a lockdep point of view, this is real.  But the page_mkwrite
code is never called on directories so it is actually safe.  We'll fix
it up.

-chris
