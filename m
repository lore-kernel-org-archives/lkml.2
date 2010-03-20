Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0CTAhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 20:37:15 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:49884 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0CTAhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 20:37:13 -0400
Message-ID: <4BA418B2.8090200@davidnewall.com>
Date: Sat, 20 Mar 2010 11:07:06 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Valery Reznic <valery_reznic@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: execve for script don't return ENOEXEC, bug ?
References: <812529.11018.qm@web110312.mail.gq1.yahoo.com> <20100319140704.794dec89.akpm@linux-foundation.org>
In-Reply-To: <20100319140704.794dec89.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 02:56:16 -0800 (PST) Valery Reznic 
<valery_reznic@yahoo.com> wrote:
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
[...]
> When I run same scripts on Fedora 12 x86_64 box with stock kernel 2.6.31.5-127.fc12.x86_64 I got following:
>
> strace -f -e execve setarch i386  ./b.sh 
> execve("/usr/bin/setarch", ["setarch", "i386", "./b.sh"], [/* 41 vars */]) = 0
> execve("./b.sh", ["./b.sh"], [/* 41 vars */]) = 0
> It's a.sh

I see no circumstance which would make b.sh invoke a.sh (and thus emit 
"It's a.sh"). Are you sure these are the actual scripts and output?

On the other hand, if the output was "It's b.sh", this is compatible 
with many historical versions of UNIX, which assumed /bin/sh to be the 
script interpreter. On
2.6.28-16-generic #55-Ubuntu SMP i686 GNU/Linux I get successful output 
for the following variants of "x.sh":

:
echo worked

and

#!
echo worked

and

#! ./x.sh
echo worked
