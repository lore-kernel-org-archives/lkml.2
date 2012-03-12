Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2CLDm5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 23:42:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab2CLDmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 23:42:53 -0400
Message-ID: <1331523759.1932.13.camel@cr0>
Subject: Re: [PATCH] enhance usability of
 /proc/sys/net/ipv4/ip_local_reserved_ports
From: Cong Wang <amwang@redhat.com>
To: Helge Deller <deller@gmx.de>
Cc: Octavian Purdila <opurdila@ixiacom.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frank Danapfel <fdanapfe@redhat.com>, Laszlo Ersek <lersek@redhat.com>,
        Linus <torvalds@linux-foundation.org>
Date: Mon, 12 Mar 2012 11:42:39 +0800
In-Reply-To: <4F5BE563.9050506@gmx.de>
References: <4F5BE563.9050506@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Helge,

On Sun, 2012-03-11 at 00:36 +0100, Helge Deller wrote:
> When writing to the ip_local_reserved_ports proc file it will currently clear
> all previously reserved ports and update the current list with the one given 
> in the input.
> 
> This behaviour makes it's usage quite hard, for example:
> a) The generic proc filesystem limitation of only handle up to PAGE_SIZE-1
>    characters at maximum may not be sufficient to provide all your wished-to-
>    be-reserved ports at once.

Yes, this should be extended IMHO.

> b) There is no easy way to disable specific given ports, you always need to
>    give the full port list at once. This makes shell scripting hard, since
>    you need to parse everything yourself.
> c) There is no easy way to just add specific ports or port ranges. Again,
>    this would be useful for shell scripts.
> 

These could be calculated in user-space, although it maybe not as easy
as you want.

> The following patch solves this problem by simply extending the parser
> in proc_do_large_bitmap() to accept the keywords "add" and "release" in front
> of given ports or port ranges and to either add or drop the given ports
> from the already existing list.

This looks a little odd, because we do "magic" things with a sysctl
file, which is supposed to be plain text file. Do we have existing
examples?

BTW, as David mentioned, please Cc netdev next time.

Thanks.

