Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab0HRFqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:46:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51462 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0HRFqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:46:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qMt4iNtuu0gkmdG2Q3hnNjlsAsCWmiHQw8gycqxeK/tWWIZ/orP12SAi8+yI7dQ1zq
         YDxob9JcrSg/b+0bUb0G+5rcQ0PaREwexE0pKbByvoi9wauPLP7CDqDl14eZq4FhRfb8
         tXZ7TgalCSYG7LC9a43Ol4WqRqmmL1+92NY60=
Date: Wed, 18 Aug 2010 13:50:45 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] Make do_execve() take a const filename pointer
Message-ID: <20100818055045.GD5243@cr0.nay.redhat.com>
References: <20100817225256.4775.6641.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817225256.4775.6641.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 11:52:56PM +0100, David Howells wrote:
>Make do_execve() take a const filename pointer so that kernel_execve() compiles
>correctly on ARM:
>
>arch/arm/kernel/sys_arm.c:88: warning: passing argument 1 of 'do_execve' discards qualifiers from pointer target type
>
>This also requires the argv and envp arguments to be consted twice, once for
>the pointer array and once for the strings the array points to.  This is
>because do_execve() passes a pointer to the filename (now const) to
>copy_strings_kernel().  A simpler alternative would be to cast the filename
>pointer in do_execve() when it's passed to copy_strings_kernel().
>
>do_execve() may not change any of the strings it is passed as part of the argv
>or envp lists as they are some of them in .rodata, so marking these strings as
>const should be fine.
>
>Further kernel_execve() and sys_execve() need to be changed to match.
>
>This has been test built on x86_64, frv, arm and mips.
>
>Signed-off-by: David Howells <dhowells@redhat.com>
>Tested-by: Ralf Baechle <ralf@linux-mips.org>
>Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

I encountered the same issue when I worked on UML, I wanted to fix this,
but it needs lots of efforts. Thanks a lot for doing this!

This patch looks good for me,

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
