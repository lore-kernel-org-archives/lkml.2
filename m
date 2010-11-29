Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab0K2ILc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:11:32 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49458 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0K2ILb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:11:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LtcUmfeew+iX4sSYLdeNVfQupVKV62QBTu1kYd4jQklqggfMpgyPFShxQjZu9PuaTm
         n4Hweo2YTh2bx8Bpe4/PAHmO4kxy0803Ype0knxpoVBXhMh8cC26Bw/FlYfMmAP+E2e1
         YlIIUoY9G6bXAfBDCyuP2vEXM5DZdNq6Zw48c=
Date: Mon, 29 Nov 2010 16:16:19 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org, gdb@sourceware.org, hellogcc@freelists.org
Subject: Re: [PATCH] Built kernel without -O2 option
Message-ID: <20101129081619.GD5218@cr0.nay.redhat.com>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:56:15AM +0800, Hui Zhu wrote:
>Hi,
>
>Now, there are a lot of ways to debug the Linux kernel with GDB, like
>qemu, kgtp or kgdb and so on.
>But the developer more like add a printk. It have a lot of reason, a big one is:
>(gdb) p ret
>$3 = <value optimized out>
>And the code execution order is not right.
>
>This is becuase the Kernel is bult with gcc -O2.  Gcc will not
>generate enough debug message with file with -O2.
>So GDB cannot work very well with Linux kernel.
>
>So I make a patch that add a option in "Kernel hacking" called "Close
>GCC optimization".  It will make kernel be built without -O2.
>
>I built and use it in i386 and x86_64.  I will try to make it OK in other arch.
>

The problem is that some functions _have to_ be inlined and gcc without -O2
doesn't inline them. Have check all the cases? I doubt.

Also, what is size of vmlinux before applying your patch and after that?
Does it increase too much?
