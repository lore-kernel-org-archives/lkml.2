Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab0GHUOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:14:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0GHUOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:14:37 -0400
X-Authority-Analysis: v=1.1 cv=m3uZWsdZ60mJS1jUfdG7r319aoXODz2lA0fDZ62Y2bk= c=1 sm=0 a=zNANCjgXmV0A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=YlsN9AhGxcV_h8TbvoQA:9 a=7l7Ke_5fgwy8GQwrKf8SzyzRgjAA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.35 regression
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <AANLkTilsXUjNNDcC4ZA9m8hBDqzcoh5NGbNd4XX5xx5s@mail.gmail.com>
References: <loom.20100705T144459-919@post.gmane.org>
	 <20100708132237.GA22830@goodmis.org>
	 <AANLkTilsXUjNNDcC4ZA9m8hBDqzcoh5NGbNd4XX5xx5s@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 08 Jul 2010 16:14:34 -0400
Message-ID: <1278620074.1537.123.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 21:53 +0300, Zeev Tarantov wrote:

> I've just uploaded the disassembly to bugzilla:
> https://bugzilla.kernel.org/show_bug.cgi?id=16353

Thanks I'll take a look.

> 
> With gcc 4.4.4 it boots and objdump's output starts with:
> Disassembly of section .data:
> 
> ffffffff81736898 <__start_syscalls_metadata>:
> ffffffff81736898:       a3 55 5f 81 ff ff ff    mov    %eax,0xffffffff815f55
> ffffffff8173689f:       ff 00
> ffffffff817368a1:       00 00                   add    %al,(%rax)
> ffffffff817368a3:       00 06                   add    %al,(%rsi)
> ffffffff817368a5:       00 00                   add    %al,(%rax)
> 
> With gcc 4.5.1 rev. 161655 objdump shows:
> Disassembly of section .data:
> 
> ffffffff8173c438 <__start_syscalls_metadata>:
>         ...
> 
> ffffffff8173c440 <__syscall_meta__mmap>:
> ffffffff8173c440:       2b ab 5f 81 ff ff       sub    -0x7ea1(%rbx),%ebp
> ffffffff8173c446:       ff                      (bad)
> ffffffff8173c447:       ff 00                   incl   (%rax)
> ffffffff8173c449:       00 00                   add    %al,(%rax)
> ffffffff8173c44b:       00 06                   add    %al,(%rsi)
> ffffffff8173c44d:       00 00                   add    %al,(%rax)
> 
> I don't know why -D, but that's the output.
> Hope it helps.

Without -D it wont disassemble data sections.

-- Steve


