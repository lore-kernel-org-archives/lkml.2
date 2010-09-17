Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab0IQSz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:55:27 -0400
Received: from xenotime.net ([72.52.115.56]:49980 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754475Ab0IQSz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:55:26 -0400
Date: Fri, 17 Sep 2010 11:55:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Rofail Qu <rofail@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: A simple question of sys_
Message-Id: <20100917115523.3f583f8d.rdunlap@xenotime.net>
In-Reply-To: <AANLkTintKaxaAKarDPFgpDLQMVomhThYtZecp5R5Mi62@mail.gmail.com>
References: <AANLkTintKaxaAKarDPFgpDLQMVomhThYtZecp5R5Mi62@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Sep 2010 14:58:30 +0800 Rofail Qu wrote:

> How to use macro IS_ERR() ?
> 
> It defines as,
> ...
> #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
> static inline long __must_check IS_ERR(const void *ptr)
> {
> 	return IS_ERR_VALUE((unsigned long)ptr);
> }
> ...
> so when pass x as a pointer and x>=-MAX_ERRNO (including NULL or any
> valid address),
> IS_ERR() will return true!

Since your conclusion is false, some part of your premise must have a problem.
Can you find it?


> IS_ERR(x) seems to use on judge if "x" is a valid error number, right?

Yes, that's what it is for.

> So in sys_execve(),
> ...
>         long error;
> 	char* filename;
> 
> 	filename = getname(name);
> 	error = PTR_ERR(filename);
> 	if (IS_ERR(filename))     // <== should be IS_ERR((void *)error) or other?
> 		return error;
> 	error = do_execve(filename, argv, envp, regs);
> ...
> 
> Where i am wrong?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
