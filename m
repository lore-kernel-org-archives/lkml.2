Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab0IDQeo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 12:34:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38682 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab0IDQen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 12:34:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=aLVJm7O880BPJ5gXDmI+2pSJHcmkZ/NXdukeZSda8pfsm+eNkzmwyexpPhnVEM59oE
         SDGnl387NbuYT/ckiBhZS1WIc8TCP9pfWNvuC1O+8Uiui5L7KWE6JGOSFYL6yXNW00UA
         tva/Q3zhJf2u7JUKLu8JNgCDiWfqddjncEF3U=
MIME-Version: 1.0
In-Reply-To: <y0md3suzzuj.fsf@fche.csb>
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com>
 <1283504768.2100.43.camel@steven> <y0md3suzzuj.fsf@fche.csb>
From: Hui Zhu <teawater@gmail.com>
Date: Sun, 5 Sep 2010 00:34:22 +0800
Message-ID: <AANLkTinF+ZagFoLhEfpwpD+wgxq75Lrhnhp2mGLehSXJ@mail.gmail.com>
Subject: Re: Linux Kernel GDB tracepoint module 2010-8-30 release
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven <mqyoung@gmail.com>, "gdb@sourceware.org" <gdb@sourceware.org>,
        linux-kernel@vger.kernel.org, Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

I try systemtrap but got some error:

On Fri, Sep 3, 2010 at 22:05, Frank Ch. Eigler <fche@redhat.com> wrote:
>
> Steven <mqyoung@gmail.com> writes:
>
>> [...]
>>         (gdb) trace vfs_readdir
>>         Tracepoint 3 at 0xc1175690: file fs/readdir.c, line 23.
>>         (gdb) actions
>>         Enter actions for tracepoint 3, one per line.
>>         End with a line saying just "end".
>>         > collect jiffies_64
>>         > collect *file
>>         > end
>
> By the way, the systemtap equivalent would be:
>
> #! /usr/bin/stap -g
> probe kernel.function("vfs_readdir") {
>      println(%{ jiffies_64 %})
>      println($file$)
> }

parse error: expected literal string or number
	saw: embedded-code at ./1.sh:3:14
     source:      println(%{ jiffies_64 %})
                          ^
parse error: expected statement
	saw: ./1.sh EOF
2 parse error(s).
Pass 1: parse failed.  Try again with another '--vp 1' option.


>
>
>> 2) I can not collect local variable, despite I rebuild the kernel with
>> -O0 optimization option. what is the problem? Many thanks
>>         -------------------------------------------------------------------
>>         (gdb) trace fs/readdir.c:29
>>         Tracepoint 2 at 0xc11756ca: file fs/readdir.c, line 29.
>>         (gdb) actions
>>         Enter actions for tracepoint 2, one per line.
>>         End with a line saying just "end".
>>         > collect res
>>         > end
>
>
> #! /usr/bin/stap
> probe kernel.statement("*@fs/readdir.c:29") {
>      println($res)
> }
>

semantic error: not accessible at this address: identifier '$res' at ./1.sh:3:14
        source:      println($res)
                             ^
Pass 2: analysis failed.  Try again with another '--vp 01' option.
[1]+  Done                    gedit 1.sh


Could you help me with it?

Thanks,
Hui
