Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0CTJmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 05:42:06 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:32884 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab0CTJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 05:42:04 -0400
Message-ID: <4BA49864.7080503@davidnewall.com>
Date: Sat, 20 Mar 2010 20:11:56 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Valery Reznic <valery_reznic@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: execve for script don't return ENOEXEC, bug ?
References: <687582.96058.qm@web110305.mail.gq1.yahoo.com>
In-Reply-To: <687582.96058.qm@web110305.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valery Reznic wrote:
> [valery@localhost ~]$ cat a.sh 
> #!/bin/sh
> echo "It's a.sh"
> [valery@localhost ~]$ cat b.sh 
> #! ./a.sh
> echo "It's b.sh"
> [valery@localhost ~]$ 
> [valery@localhost ~]$ strace -f -e execve setarch i386 ./b.sh 
> execve("/usr/bin/setarch", ["setarch", "i386", "./b.sh"], [/* 40 vars */]) = 0
> execve("./b.sh", ["./b.sh"], [/* 40 vars */]) = 0
> It's a.sh
>   

That is the correct output for a script which is being interpreted by 
a.sh, when a.sh prints "It's a.sh" using /bin/sh as its interpreter.  
Remember, you didn't ask /bin/sh to interpret b.sh, you asked a.sh to do 
it, and a.sh is a simple echo statement, not an interpreter.  There is 
no error here.
