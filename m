Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0CSVHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:07:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492Ab0CSVHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:07:06 -0400
Date: Fri, 19 Mar 2010 14:07:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valery Reznic <valery_reznic@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: execve for script don't return ENOEXEC, bug ?
Message-Id: <20100319140704.794dec89.akpm@linux-foundation.org>
In-Reply-To: <812529.11018.qm@web110312.mail.gq1.yahoo.com>
References: <812529.11018.qm@web110312.mail.gq1.yahoo.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 02:56:16 -0800 (PST)
Valery Reznic <valery_reznic@yahoo.com> wrote:

> Hi,
> 
> I Have following to scripts:
> 
> a.sh
> #!/bin/sh
> echo "It's a.sh
> 
> and b.sh:
> #! ./b.sh
> echo "It's b.sh"
> 
> As per execve man page, script interpreter should not be script itself.
> When I run it on my Fedora 8 x86_64 box (with stock kernel, never updated)
> under strace I got following:
> 
> strace -f -e execve  setarch x86_64  ./b.sh 
> execve("/usr/bin/setarch", ["setarch", "x86_64", "./b.sh"], [/* 23 vars */]) = 0
> execve("./b.sh", ["./b.sh"], [/* 23 vars */]) = -1 ENOEXEC (Exec format error)
> execve("/bin/sh", ["/bin/sh", "./b.sh"], [/* 23 vars */]) = 0
> It's b.sh
> 
> I.e execve failed as it should
> 
> When I run same scripts on Fedora 12 x86_64 box with stock kernel 2.6.31.5-127.fc12.x86_64 I got following:
> 
> strace -f -e execve setarch i386  ./b.sh 
> execve("/usr/bin/setarch", ["setarch", "i386", "./b.sh"], [/* 41 vars */]) = 0
> execve("./b.sh", ["./b.sh"], [/* 41 vars */]) = 0
> It's a.sh
> 
> I.e execve succeeded, instead of failing with ENOEXEC
> 

It works for me, I think:

z:/home/akpm> uname -a
Linux z 2.6.31.5-127.fc12.x86_64 #1 SMP Sat Nov 7 21:11:14 EST 2009 x86_64 x86_64 x86_64 GNU/Linux
z:/home/akpm> cat b.sh
#! ./b.sh
echo "It's b.sh"
z:/home/akpm> strace -f -e execve setarch i386  ./b.sh 
execve("/usr/bin/setarch", ["setarch", "i386", "./b.sh"], [/* 60 vars */]) = 0
execve("./b.sh", ["./b.sh"], [/* 60 vars */]) = -1 ENOEXEC (Exec format error)
execve("/bin/sh", ["/bin/sh", "./b.sh"], [/* 60 vars */]) = 0
It's b.sh


Did I do something wrong?  If not, I wonder what's different.
