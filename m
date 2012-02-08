Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2BHVbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:31:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49893 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756342Ab2BHVbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:31:06 -0500
Message-ID: <4F32E98F.2090909@zytor.com>
Date: Wed, 08 Feb 2012 13:30:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 21/21] posix_types: Remove fd_set macros
References: <4F32A98F.7030400@zytor.com> <1328677745-20121-22-git-send-email-hpa@zytor.com> <1328677745-20121-1-git-send-email-hpa@zytor.com> <8328.1328703626@redhat.com> <16325.1328736262@redhat.com>
In-Reply-To: <16325.1328736262@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2012 01:24 PM, David Howells wrote:
> H. Peter Anvin<hpa@zytor.com>  wrote:
>
>> Anyway, select() paraphernalia goes in<sys/time.h>  (as opposed to
>> <time.h>), poll() paraphernalia goes in<sys/poll.h>, and the linux/*
>> files mimics that.
>
> That doesn't seem to be so - at least not for my copy of glibc:
>
> /usr/include/sys/select.h:/* fd_set for select and pselect.  */
> /usr/include/sys/select.h:  } fd_set;
> /usr/include/sys/select.h:#define       FD_ISSET(fd, fdsetp)    __FD_ISSET (fd, fdsetp)
>
> Besides, this is inside the kernel.  The I/O polling architecture definitions
> (which includes select) ought to be in one place there, not spread out all
> over the place.
>

I think <sys/select.h> is more recent, but anyway, look at the existing 
<linux/time.h> and you see why it's there.

It's fine to say it shouldn't be, but then ALL the definitions should 
move (and that should be a separate change from this patchset)... but do 
note that some of those macro definitions (which I did NOT change) are 
exported to user space so make those changes with care.

	-hpa


