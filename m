Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab1ERPzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 11:55:04 -0400
Received: from mail4.comsite.net ([205.238.176.238]:20656 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab1ERPzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 11:55:01 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
To: Stevie Trujillo <stevie.trujillo@gmail.com>
In-Reply-To: <201105181637.46164.stevie.trujillo@gmail.com>
References: <201105181637.46164.stevie.trujillo@gmail.com>
From: Milton Miller <miltonm@bga.com>
Subject: Re: How to get backtrace? modprobe -r iwlagn; modprobe iwlagn kills kernel
Cc: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
Date: Wed, 18 May 2011 10:55:01 -0500
X-Originating-IP: 71.22.127.106
Message-ID: <1305734101_6569@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed May 18 2011 about 10:37:54 EST, Stevie Trujillo wrote:
> I'm having some problem getting a backtrace. When I do "modprobe -r
> iwlagn; modprobe iwlagn" (2.6.38.6 with Intel-1030N) the kernel crashes
> (sometimes I need to try 2 or 3 times, and sometimes the modprobe -r
> is the one that crashes).
> 
> This spams my monitor with several oops/panics before it finally
> dies. I can only see bottom of the last one, which probably isn't
> very meaningful.  I tried loading netconsole, but I only get one or
> two lines before it stops sending/printing.
> 
> I then tried kexec+crashkernel, but I only managed to get a backtrace
> for the last panic (which I think is just a result of memory corruption
> or something).  Finally I tried compiling ramoops into my kernel,
> but it didn't want to load because of "No such device".

For the kexec+crashkernel, try to retrieve the kernel log buffer:

There are some macros available, but basically log_buf is a pointer
to a buffer of length log_buf_len initialized to __log_buf (but can
be expanded via the command line or sysctl, in). log_end is the
end of the buffer.  If you haven't wrapped then just print log_end
characters.

Also consider setting /proc/sys/kernel/panic_on_oops to 1 to
concentrate on the first one.  It won't help getting the oops to your
syslog but maybe it will keep it on the screen.

Hope this helps,
milton
