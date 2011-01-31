Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1AaR7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 12:59:15 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42085 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab1AaR7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 12:59:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TzNHw52Ydqym7LYT72TcF5OAhsW1JDiVhJvpBTftna4VIfMXddrCiLh1FCOvz8w1s9
         T3Vvdiunbz1M3YJwhTBX9wfKja7YXyyCVgej0TXn7Az5wAIWzdEuLZ3Q8LZFKaWS5bFi
         vCnKPvVXZ9Tn/hDjG4IXKJetEcJR1wM/AI3vU=
MIME-Version: 1.0
In-Reply-To: <AANLkTinR=GN+rNqAUcFrnUXea0aWmew-wde0oP22uPcj@mail.gmail.com>
References: <AANLkTinR=GN+rNqAUcFrnUXea0aWmew-wde0oP22uPcj@mail.gmail.com>
Date: Mon, 31 Jan 2011 23:28:52 +0530
Message-ID: <AANLkTik76t-BUv0SUMOCBaoiGhH0PKq7cQwM8Q1Lmkei@mail.gmail.com>
Subject: Re: Please correct this code
From: Rajat Sharma <fs.rajat@gmail.com>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is is not that Code A is wrong, for not mentioning cobbler list
> 'memory' to indicate memory contents are getting updated.
> Please rectify me, if I am wrong.

>From Code B, it looks like instruction to compiler for not using extra
memory location other than ones specified for input param and output
param. Is it some sort of memory synchronization code?

> Also, what does '+m' constraint mean, if I use in inline assembly.

It means the memory location for param is both Readable and Writable

Rajat

On Mon, Jan 31, 2011 at 10:07 PM, Sri Ram Vemulpali
<sri.ram.gmu06@gmail.com> wrote:
> Hi,
>
> I have following snippet of code.
>
> Code A
>
> __asm__ __volatile__(
>                     "   lock       ;\n"
>                     "   addl %1,%0 ;\n"
>                     : "=m"  (my_var)
>                     : "ir"  (my_int), "m" (my_var)
>                     :                                 /* no clobber-list */
>                     );
>
> Code B
>
>  __asm__ __volatile__(  "decl %0; sete %1"
>                     : "=m" (my_var), "=q" (cond)
>                     : "m" (my_var)
>                     : "memory"
>                     );
>
> In Code A memory contents are getting updated. And in Code B memory
> contents and 'cond' var are getting updated.
> In Code B in cobbler column 'memory' is used to indicate that this
> code modifies memory contents. But where as in Code A it was not
> mentioned
>
> Is is not that Code A is wrong, for not mentioning cobbler list
> 'memory' to indicate memory contents are getting updated.
> Please rectify me, if I am wrong.
>
> Also, what does '+m' constraint mean, if I use in inline assembly.
> --
> Regards,
> Sri.
>
> _______________________________________________
> Kernelnewbies mailing list
> Kernelnewbies@kernelnewbies.org
> http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
>
