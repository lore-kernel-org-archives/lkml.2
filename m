Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1C0SLP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 14:11:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42788 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab1C0SLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 14:11:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=bHzXQiDulOV4bdizh7qyikech28Q4PKusRsbxEY73Zftlbx1k5MJdT2zcmN7XFr7Wh
         jFQdOanOdvWvmQvGotMssdENXqeQtPgpAEpNSqZpYks9LuEcLwGa3UAjzEk2pGIHy3g2
         4AUT9xSWQIryCBjTepOUI+zZX0VmWePvDUsnw=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Sean Noonan <Sean.Noonan@twosigma.com>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Date: Sun, 27 Mar 2011 20:11:06 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38; KDE/4.4.5; i686; ; )
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        Stephen Degler <Stephen.Degler@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103272011.07282.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=31982
for your bug report, please add your address to the CC list in there, thanks!

On poniedziałek, 21 marca 2011 o 17:19:44 Sean Noonan wrote:
> This message was originally posted to the XFS mailing list, but received no
> responses.  Thus, I am sending it to LKML on the advice of Martin.
> 
> Using the attached program, we are able to reproduce this bug reliably.
> $ make vmtest
> $ ./vmtest /xfs/hugefile.dat $(( 16 * 1024 * 1024 * 1024 )) # vmtest
> <path_to_file> <size_in_bytes> /xfs/hugefile.dat: mapped 17179869184 bytes
> in 33822066943 ticks
> 749660: avg 13339 max 234667 ticks
> 371945: avg 26885 max 281616 ticks
> ---
> At this point, we see the following on the console:
> [593492.694806] XFS: possible memory allocation deadlock in kmem_alloc
> (mode:0x250) [593506.724367] XFS: possible memory allocation deadlock in
> kmem_alloc (mode:0x250) [593524.837717] XFS: possible memory allocation
> deadlock in kmem_alloc (mode:0x250) [593556.742386] XFS: possible memory
> allocation deadlock in kmem_alloc (mode:0x250)
> 
> This is the same message presented in
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=410
> 
> We started testing with 2.6.38-rc7 and have seen this bug through to the .0
> release.  This does not appear to be present in 2.6.33, but we have not
> done testing in between.  We have tested with ext4 and do not encounter
> this bug. CONFIG_XFS_FS=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> # CONFIG_XFS_DEBUG is not set
> # CONFIG_VXFS_FS is not set
> 
> Here is the stack from the process:
> [<ffffffff81357553>] call_rwsem_down_write_failed+0x13/0x20
> [<ffffffff812ddf1e>] xfs_ilock+0x7e/0x110
> [<ffffffff8130132f>] __xfs_get_blocks+0x8f/0x4e0
> [<ffffffff813017b1>] xfs_get_blocks+0x11/0x20
> [<ffffffff8114ba3e>] __block_write_begin+0x1ee/0x5b0
> [<ffffffff8114be9d>] block_page_mkwrite+0x9d/0xf0
> [<ffffffff81307e05>] xfs_vm_page_mkwrite+0x15/0x20
> [<ffffffff810f2ddb>] do_wp_page+0x54b/0x820
> [<ffffffff810f347c>] handle_pte_fault+0x3cc/0x820
> [<ffffffff810f5145>] handle_mm_fault+0x175/0x2f0
> [<ffffffff8102e399>] do_page_fault+0x159/0x470
> [<ffffffff816cf6cf>] page_fault+0x1f/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> # uname -a
> Linux testhost 2.6.38 #2 SMP PREEMPT Fri Mar 18 15:00:59 GMT 2011 x86_64
> GNU/Linux
> 
> Please let me know if additional information is required.
> 
> Thanks!
> 
> Sean

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
