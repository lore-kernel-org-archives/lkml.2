Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab0ICOGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:06:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab0ICOGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:06:08 -0400
To: Steven <mqyoung@gmail.com>
Cc: Hui Zhu <teawater@gmail.com>, "gdb@sourceware.org" <gdb@sourceware.org>,
        linux-kernel@vger.kernel.org, Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>
Subject: Re: Linux Kernel GDB tracepoint module 2010-8-30 release
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com>
	<1283504768.2100.43.camel@steven>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 03 Sep 2010 10:05:56 -0400
In-Reply-To: <1283504768.2100.43.camel@steven> (mqyoung@gmail.com's message of "Fri, 03 Sep 2010 17:06:08 +0800")
Message-ID: <y0md3suzzuj.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Steven <mqyoung@gmail.com> writes:

> [...]
>         (gdb) trace vfs_readdir 
>         Tracepoint 3 at 0xc1175690: file fs/readdir.c, line 23.
>         (gdb) actions
>         Enter actions for tracepoint 3, one per line.
>         End with a line saying just "end".
>         > collect jiffies_64
>         > collect *file
>         > end

By the way, the systemtap equivalent would be:

#! /usr/bin/stap -g
probe kernel.function("vfs_readdir") {
      println(%{ jiffies_64 %})
      println($file$)
}


> 2) I can not collect local variable, despite I rebuild the kernel with
> -O0 optimization option. what is the problem? Many thanks
>         -------------------------------------------------------------------
>         (gdb) trace fs/readdir.c:29
>         Tracepoint 2 at 0xc11756ca: file fs/readdir.c, line 29.
>         (gdb) actions 
>         Enter actions for tracepoint 2, one per line.
>         End with a line saying just "end".
>         > collect res
>         > end


#! /usr/bin/stap
probe kernel.statement("*@fs/readdir.c:29") {
      println($res)
}


- FChE
