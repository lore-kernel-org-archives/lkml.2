Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab0DUIm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:42:56 -0400
Received: from mail.agmk.net ([91.192.224.71]:42456 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab0DUImy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:42:54 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Yann Droneaud" <yann@droneaud.fr>
Cc: libc-help@sourceware.org, "Mike Frysinger" <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
Subject: Re: mprotect() failed: Cannot allocate memory
References: <201004210105.20942.pluto@agmk.net>
 <201004201917.23286.vapier@gentoo.org> <201004210144.18954.pluto@agmk.net>
 <1271838139.28592.10.camel@localhost>
Date: Wed, 21 Apr 2010 10:42:45 +0300
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: =?utf-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>
Message-ID: <op.vbh7tjp0zu3k57@pawels.alatek.krakow.pl>
In-Reply-To: <1271838139.28592.10.camel@localhost>
User-Agent: Opera Mail/10.51 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 21-04-2010 o 11:22:19 Yann Droneaud <yann@droneaud.fr> napisał(a):

>> (...)
>> mmap(NULL, 4896, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0)  
>> =
>> 0x7f5fd97df000
>> mprotect(0x7f5fd97df000, 4096, PROT_NONE) = -1 ENOMEM (Cannot allocate  
>> memory)
>
> Have you checked available memory on your system ? Or user limit ?
>
> You test program is going to allocate
>  79 + 1 pages for bm
>  1 + 1 for each double arrays (x 40000)
>
> So in the end your program is allocating 80080 pages, so about
> 312MBytes.
>
> It not that big for a 64bits system.

afaics in gdb, the mprotect fails at i=32756. it's near to 2^15.
maybe some kernel data structures are full?
