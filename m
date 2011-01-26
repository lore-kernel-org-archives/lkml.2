Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1AZUbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:31:55 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52246 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1AZUby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:31:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=NyZdKIJF1W1T0Qcvnn3bI57MuYGp8msvNkc1+EegP5/QIPH5IyvpWYkSXz2Rm6N8Is
         ft5OQnMv/XTxCw9EqIHVKaygZdslYDXn4ynuj0074ZSudRraB38MOkhXodk11EkqSiw4
         fQ7RLyIo/syiXIz/cxYsjzb/tffG6rUmBk5/w=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Tao Ma <tm@tao.ma>
Subject: Re: 38-rc1: umount+rmmod cause ext4 error.
Date: Wed, 26 Jan 2011 21:28:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2; KDE/4.4.5; i686; ; )
Cc: npiggin@gmail.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
References: <4D368A70.5030103@tao.ma>
In-Reply-To: <4D368A70.5030103@tao.ma>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101262128.25528.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=27652
for your bug report, please add your address to the CC list in there, thanks!

On środa, 19 stycznia 2011 o 07:53:36 Tao Ma wrote:
> Hi Nick and Ted,
> 	I ran some very basic test with 38-rc1 and my box run into error with
> the message like:
> 
> slab error in kmem_cache_destroy(): cache `ext4_inode_cache': Can't free
> all objects
> Pid: 4395, comm: rmmod Not tainted 2.6.38-rc1 #1
> Call Trace:
>   [<ffffffff820d61dc>] ? kmem_cache_destroy+0x83/0xc7
>   [<ffffffffa0574025>] ? destroy_inodecache+0x15/0x17 [ext4]
>   [<ffffffffa05923d1>] ? ext4_exit_fs+0x109/0x143 [ext4]
>   [<ffffffff8203d194>] ? put_online_cpus+0x56/0x58
>   [<ffffffff8206735a>] ? module_refcount+0x85/0x9d
>   [<ffffffff82067b22>] ? sys_delete_module+0x1b5/0x218
>   [<ffffffff82074fc3>] ? audit_syscall_entry+0x187/0x1ba
>   [<ffffffff82002a6b>] ? system_call_fastpath+0x16/0x1b
> SLAB: cache with size 888 has lost its name
> SLAB: cache with size 888 has lost its name
> SLAB: cache with size 888 has lost its name
> SLAB: cache with size 888 has lost its name
> 
> The reproduce process is simple:just rmmod ext4 immediately after umount
> an ext4 volume.
> 
> I have done some very simple investigation and it seems that with Nick's
> new ext4_i_callback, even after we do ext4_destroy_inode, it isn't
> freed. So after we destroy the ext_inode_cache, and when freeing the
> inode, it errors. Hope it helps. If you have any fixes, I can test it.
> 
> Regards,
> Tao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
