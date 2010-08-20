Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab0HTWec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 18:34:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33608 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab0HTWea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 18:34:30 -0400
Date: Fri, 20 Aug 2010 15:32:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: runcoderen <runcoderzhcn@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sys_init_module system call
Message-Id: <20100820153254.3a87be2f.randy.dunlap@oracle.com>
In-Reply-To: <1282342684.1631.4.camel@bencharluo-laptop>
References: <20100818041333.GA14149@lixom.net>
	<20100818171636.0625b668.akpm@linux-foundation.org>
	<20100819032230.GA21980@lixom.net>
	<20100820010242.GA29588@lixom.net>
	<20100820221323.GC8535@lixom.net>
	<1282342684.1631.4.camel@bencharluo-laptop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Aug 2010 06:18:04 +0800 runcoderen wrote:

> hi all
> I find sys_init_module system call in kernel/module.c file.
> but it did not find any.
> the source code version is linux-2.6.35
> 
> does the kernel have changed?
> 
> the book I am reading is LDD 3rd edition

You won't find a function in kernel/module.c that looks like it has
the name "sys_init_module".  Instead, the function is defined by using
a macro, and it looks like this:

/* This is where the real work happens */
SYSCALL_DEFINE3(init_module, void __user *, umod,
		unsigned long, len, const char __user *, uargs)
{



The use of SYSCALL_DEFINEx(func_name, args) is a fairly recent change
(well, January, 2009) that may be the reason why you think that there
has been a change.  See
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1a94bc34768e463a93cb3751819709ab0ea80a01


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
