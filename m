Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab0GHSxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 14:53:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51285 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307Ab0GHSxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 14:53:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ImEDT37DZMBGWS5G9xDFN7h2XWecYl9e3GKbVStCs+d0M1fOM4huTbUXKc3lYkL9Iz
         8tAju17K8DIyF13OultbnupbL6kD0N8HHA4C9NxrmskZRTOl6Ne1FGg79ek+YFVx2ivd
         +2db9IcU78JulSrfF/I2wwZ3k0x9VJnJzbM+A=
MIME-Version: 1.0
In-Reply-To: <20100708132237.GA22830@goodmis.org>
References: <loom.20100705T144459-919@post.gmane.org> <20100708132237.GA22830@goodmis.org>
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Thu, 8 Jul 2010 21:53:27 +0300
Message-ID: <AANLkTilsXUjNNDcC4ZA9m8hBDqzcoh5NGbNd4XX5xx5s@mail.gmail.com>
Subject: Re: 2.6.35 regression
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 16:22, Steven Rostedt <rostedt@goodmis.org> wrote:
> Zeev, can you try to reproduce it with gcc 4.4.
>
> And for now could you send me the output of this:
>
>  objdump -Dr --start-addr 0x`nm vmlinux | grep __start_syscalls_metadata | cut -d' ' -f 1` \
>    --stop-addr 0x`nm vmlinux | grep __stop_syscalls_metadata | cut -d' ' -f 1` vmlinux
>
> You need to go into the directory that has the vmlinux built.
>
> -- Steve

I've just uploaded the disassembly to bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=16353

With gcc 4.4.4 it boots and objdump's output starts with:
Disassembly of section .data:

ffffffff81736898 <__start_syscalls_metadata>:
ffffffff81736898:       a3 55 5f 81 ff ff ff    mov    %eax,0xffffffff815f55
ffffffff8173689f:       ff 00
ffffffff817368a1:       00 00                   add    %al,(%rax)
ffffffff817368a3:       00 06                   add    %al,(%rsi)
ffffffff817368a5:       00 00                   add    %al,(%rax)

With gcc 4.5.1 rev. 161655 objdump shows:
Disassembly of section .data:

ffffffff8173c438 <__start_syscalls_metadata>:
        ...

ffffffff8173c440 <__syscall_meta__mmap>:
ffffffff8173c440:       2b ab 5f 81 ff ff       sub    -0x7ea1(%rbx),%ebp
ffffffff8173c446:       ff                      (bad)
ffffffff8173c447:       ff 00                   incl   (%rax)
ffffffff8173c449:       00 00                   add    %al,(%rax)
ffffffff8173c44b:       00 06                   add    %al,(%rsi)
ffffffff8173c44d:       00 00                   add    %al,(%rax)

I don't know why -D, but that's the output.
Hope it helps.

-Zeev
