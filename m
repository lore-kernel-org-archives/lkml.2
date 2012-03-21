Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030946Ab2CUORx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 10:17:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60689 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab2CUORv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 10:17:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lubos Lunak <l.lunak@suse.cz>
Subject: Re: [PATCH] do not export kernel's NULL #define to userspace
Date: Wed, 21 Mar 2012 14:17:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <201203211408.25040.l.lunak@suse.cz> <201203211332.06018.arnd@arndb.de> <201203211509.27977.l.lunak@suse.cz>
In-Reply-To: <201203211509.27977.l.lunak@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203211417.14306.arnd@arndb.de>
X-Provags-ID: V02:K0:3YzuBxIsVI59Xaflq63UlBJzfHbxMJfCkFnUgu92PX4
 xfhDAHHCGI1Hvnj9lBtVTXZnE+imDIpnFwxtvIfrRptgkXWI4/
 4VbkwFZRmG+qndEI1U9WYy6++ndYi69USa4238+JhUSyn1A3bW
 6nGHOsJsLV7UfBcbL5Su1hlRW/GhEJbOrWqtNvD8VNNUP2mCXp
 6PX7BqI4WNwNAD2ZpepWMbpSZtw/cb5wH3vLed5o58BxGZcLNL
 gshp503ib96ef0nqNkzYb+8LLXQFNuW6/4h6A6ihqOABzx1o0+
 yXzcRamUHCNJPvuGQqSyVvHH8sCDz/pf51YYdQHJY9i8bi8+Lu
 VzJV+qPfLJ70JvSTJXZg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2012, Lubos Lunak wrote:
> > If so, we might have to replace it with a __KERNEL_NULL constant
> > or something, like we do for the stuff in linux/types.h, so we
> > don't accidentally break user applications that rely on the
> > header files to be self-contained.
> >
> > I think there is at least a NULL usage in linux/wireless.h and some
> > netfilter headers.
> 
>  I see. How about the attached patch then?

Strictly speaking, you should not include standard headers from kernel
provided headers, and the problems would be similar to those before
your patch: anyone who currently doesn't include <stddef.h> but has
their own definition of NULL will still get a conflict from including
a kernel header that includes <linux/stddef.h>.

	Arnd
