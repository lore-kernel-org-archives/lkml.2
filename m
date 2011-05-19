Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934735Ab1ESUnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:43:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40860 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934077Ab1ESUnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:43:51 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=XYJHFtupD_QA:10 a=TwWXrjo8ZJIA:10 a=5SG0PmZfjMsA:10 a=8nJEP1OIZ-IA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=dObB1cEt5XO7rS6OecIA:9 a=mXLHnUKgPmtDsm5w05sA:7 a=wPNLvfGTeEIA:10 a=x8gzFH9gYPwA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 19 May 2011 16:43:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
Message-ID: <20110519204342.GA10792@home.goodmis.org>
References: <201105191526.31904.toralf.foerster@gmx.de>
 <BANLkTi=FinuAYpYXf1K6pQ-3i2vRJS=g9g@mail.gmail.com>
 <201105192218.18261.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201105192218.18261.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:18:16PM +0200, Toralf Förster wrote:
> 
> richard -rw- weinberger wrote at 19:00:35
> > Can you bisect the issue?

Is this bug fully reproducable? If not, then you may have had a git
bisect good, when it should have been git bisect bad.

The futex/plist should not be affecting rwsem.

-- Steve

> 
> tfoerste@n22 ~/devel/linux-2.6 $ git bisect bad
> 2e12978a9f7a7abd54e8eb9ce70a7718767b8b2c is the first bad commit
> commit 2e12978a9f7a7abd54e8eb9ce70a7718767b8b2c
> Author: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date:   Wed Dec 22 14:18:50 2010 +0800
> 
>     futex,plist: Pass the real head of the priority list to plist_del()
>     
>     Some plist_del()s in kernel/futex.c are passed a faked head of the
>     priority list.
>     
>     It does not fail because the current code does not require the real head
>     in plist_del(). The current code of plist_del() just uses the head for 
> checking,
>     so it will not cause a bad result even when we use a faked head.
>     
>     But it is undocumented usage:
>     
>     /**
>      * plist_del - Remove a @node from plist.
>      *
>      * @node:   &struct plist_node pointer - entry to be removed
>      * @head:   &struct plist_head pointer - list head
>      */
>     
>     The document says that the @head is the "list head" head of the priority 
> list.
>     
>     In futex code, several places use "plist_del(&q->list, &q->list.plist);",
>     they pass a fake head. We need to fix them all.
>     
>     Thanks to Darren Hart for many suggestions.
>     
>     Acked-by: Darren Hart <dvhart@linux.intel.com>
>     Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
>     LKML-Reference: <4D11984A.5030203@cn.fujitsu.com>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> :040000 040000 78d47de377f8da1c131007a17ca915fbd13f7ff6 
> ffac93205aaf22fda0667d6395c8da7c7bf692e4 M      kernel
> 
> -- 
> MfG/Sincerely
> Toralf Förster
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
