Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161609Ab1FAMgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:36:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50595 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161179Ab1FAMgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=mdXdhJvQuWCPTfWdnqOGN7A/wndRLV7Vy+1UzBzjVRMF6tUodhtXX9AV5l+8LiAj+q
         WPvT8UW1RbLKh6HOB5XEShxTEb32zS52uBQ9EgrlJthpF1U4vUHRNkPiGdYXJ9lajZ2O
         PnyAg4ycHhKeE2dOT3YuPwAEOJxUiaku7AVns=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=FCwtiyRGEuueD_vP+BLHHPzCpBw@mail.gmail.com>
References: <cover.1306847455.git.luto@mit.edu> <06958cd58d0de8b0c674c9b3fa37f9a297ee90f2.1306847455.git.luto@mit.edu>
 <BANLkTi=FCwtiyRGEuueD_vP+BLHHPzCpBw@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 1 Jun 2011 08:36:20 -0400
X-Google-Sender-Auth: jMEDhRZsyc_VF40daiodvbqd9jE
Message-ID: <BANLkTi=mhNZcTJvWdPLAbJFo383iRfucOg@mail.gmail.com>
Subject: Re: [PATCH v3 08/10] x86-64: Emulate legacy vsyscalls
To: Brian Gerst <brgerst@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 7:54 AM, Brian Gerst <brgerst@gmail.com> wrote:
> On Tue, May 31, 2011 at 9:16 AM, Andy Lutomirski <luto@mit.edu> wrote:
>> There's a fair amount of code in the vsyscall page.  It contains a
>> syscall instruction (in the gettimeofday fallback) and who knows
>> what will happen if an exploit jumps into the middle of some other
>> code.
>>
>> Reduce the risk by replacing the vsyscalls with short magic
>> incantations that cause the kernel to emulate the real vsyscalls.
>> These incantations are useless if entered in the middle.
>
> How about remapping the vsyscall page into a random page in the
> modules area, and make the fixed page simply have stubs that jump to
> the code in that page.  That would solve the fixed address syscall
> problem without any more overhead.

It wouldn't give any protection against local attacks, though.

--Andy

>
> --
> Brian Gerst
>
