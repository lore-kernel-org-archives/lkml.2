Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2BGD53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 22:57:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab2BGD52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 22:57:28 -0500
Message-ID: <4F30A120.2050208@redhat.com>
Date: Mon, 06 Feb 2012 22:57:20 -0500
From: Adam Jackson <ajax@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH] char/mem: Make /dev/port less obviously broken (v0)
References: <1328569322-19165-1-git-send-email-ajax@redhat.com> <20120207001558.GA30840@kroah.com>
In-Reply-To: <20120207001558.GA30840@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/12 7:15 PM, Greg KH wrote:

> Who would use this new ioctl?  And if it's been working ok until now,
> why is it needed?

I'll go out on a limb and say nobody's been seriously using /dev/port. 
libpciaccess would like to, since it avoids needing iopl, and also 
avoids duplicating all the kernel's per-arch logic for port access in 
userspace.  But if it's not going to give me the cycle size I asked for 
I need to fix it before I can use it.  Otherwise you get what I'm 
getting, which is a vesa driver that doesn't work.

Adding the ioctl was just me being polite and assuming that user-kernel 
ABI was a thing we actually believe in.  If it's not, great, let's just 
fix /dev/port to not be idiotic.  If it is, I'd prefer not wasting the 
memory on another inode.

> If you want something "new" like this, why not just create /dev/ioport
> or something like that to always use the proper alignment and not need
> an ioctl at all?

If you really want that shed painted a different color, fine.

- ajax
