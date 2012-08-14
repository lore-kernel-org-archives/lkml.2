Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab2HNQdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 12:33:50 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49759 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab2HNQdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 12:33:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAHP4M8UhnkB085V8X5LVuj-JScdZWJdjcDMzvgwoL_opKKRpOw@mail.gmail.com>
References: <CAHP4M8WV64UMor_oU4UNgGx7P0Zet_M3yJrAZaCR+yYQmmeEYw@mail.gmail.com>
	<20120814134020.367361b5@pyramind.ukuu.org.uk>
	<CAHP4M8UhnkB085V8X5LVuj-JScdZWJdjcDMzvgwoL_opKKRpOw@mail.gmail.com>
Date: Tue, 14 Aug 2012 18:33:46 +0200
Message-ID: <CAFLxGvx9hDn01J3qmFggnQzsW5+g=ZJaezH9yu5d+cm3qhM_JQ@mail.gmail.com>
Subject: Re: How to hack syscall-table, in kernel 2.6+ ?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Ajay Garg <ajaygargnsit@gmail.com>
Cc: balbi@ti.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 6:13 PM, Ajay Garg <ajaygargnsit@gmail.com> wrote:
> So, the use-case I am trying to solve, is that only a particular
> process should be able to read a group of files, and no one else (i.e.
> no-other-user/ no-other-process/no-other-anything). The only exception
> is the "root" user, and any user holding "sudo" previleges.
>
> So, only a particular process (with a specified PID), the superuser,
> and any user-carrying-sudo previleges, should be able to read a group
> of files.

Sounds like a use case for a LSM (like SELinux).

Let's suppose you hook open().
Your code will notice open("/bin/foo/", ...)
But you cannot just filter for /bin/foo, you have to know much more context.
What's the current tasks root directory? Which namespace, etc.
Of course you can gather all this information but it will make your
code large and buggy.

-- 
Thanks,
//richard
