Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583Ab0LUEqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 23:46:52 -0500
Received: from smtp-out.google.com ([74.125.121.67]:3174 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933560Ab0LUEqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 23:46:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=t0U7kvkO2IfRbS/H9qmAX3hRrb4DxJzXwjlIMbVbZY3CsTOHnWVdvCON5ZMPBx1GJN
         ZL32rZXk4oIaQKLflFlQ==
Date: Mon, 20 Dec 2010 20:46:40 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: AJ ONeal <coolaj86@gmail.com>
cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Memory Leak in /dev/shm on ARM 2.6.36
In-Reply-To: <AANLkTimze4agnNRM_HVnQ1=B44pWy_D+OmeUYFvCSwMy@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1012202037080.15253@tigran.mtv.corp.google.com>
References: <AANLkTimze4agnNRM_HVnQ1=B44pWy_D+OmeUYFvCSwMy@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010, AJ ONeal wrote:

> In my other message about SIGBUS I was mmap-ing a file in /dev/shm.
> 
> I switched my implementation to use write() instead of mmap and now it
> leaks memory very very quickly.
> 
> `df -h` shows that 80mb of memory are in use
> `du -ch /dev/shm` shows that 10mb of memory in use
> 
> After just a few minutes of creating and removing 512kb files in
> /dev/shm the program exits with a write failure.
> Unmounting and remounting /dev/shm reclaims the memory.

I'm interested, but won't have any time to investigate for several days.

The usual reason (for such a large df/du discrepancy) would be something
holding open the unlinked files; but if that were the case, then umount
would fail, complaining that the mount is busy.

Can you please try x86 and see if the same happens there with your
program?  (I've got x86 but not arm: I see no problem on x86,
but I'm probably not doing exactly what you're doing.)

Can you please try 2.6.35 and see if that behaves in the same way?
There were some shmem block accounting changes in 2.6.36, I wonder
if they're misbehaving on arm.

Thanks,
Hugh
