Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab1E2O7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 10:59:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63822 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1E2O7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 10:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=lEKrCiRh5TpV4lZUx3I9dYItu1TkN1fsgl8AWXlu8fUWm+sfz8QFOIKZ/3UmUfN+gH
         hwKSgwjuWzUC4hMd+vtOniwsGRLgEcAXJ8LLzmk2z6+JUUFhzUlU4sObPCgWv5V17rt7
         fYnM1mnFhQira0KJsCYaxnmGrJqkv11B9U5mA=
MIME-Version: 1.0
In-Reply-To: <19938.23219.306163.24059@pilspetsen.it.uu.se>
References: <alpine.LFD.2.02.1105262049180.3078@ionos> <4DDEC589.3010201@mit.edu>
 <20110527061208.GB9260@elte.hu> <BANLkTinOQ_C_-Bix4FTQxHqP3aavmTRrzg@mail.gmail.com>
 <BANLkTikKAx=KXZuECAXaskhZOre-2ZHutw@mail.gmail.com> <20110528153536.GB27104@elte.hu>
 <19938.23219.306163.24059@pilspetsen.it.uu.se>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 29 May 2011 10:59:11 -0400
X-Google-Sender-Auth: qQJs0SZ3LxE7wKJFe3pwSm4YCA8
Message-ID: <BANLkTi=y2vGbj_LMqyXzj4JPL+w_KL+=yQ@mail.gmail.com>
Subject: Re: [GIT pull] x86 vdso updates
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 10:39 AM, Mikael Pettersson <mikpe@it.uu.se> wrote:
> Ingo Molnar writes:
>  >
>  > * Andrew Lutomirski <luto@mit.edu> wrote:
>  >
>  > > On Fri, May 27, 2011 at 7:36 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>  > > > 3. Add int 0xcc and use it from vgettimeofday.  It will SIGSEGV if
>  > > > called from a user address (so it has no risk of ever becoming ABI)
>  > > > and it will do gettimeofday if called from the right address.  (I like
> ...
>  > > Make it a real syscall but with extra constraints.  It would have the
>  > > same calling convention as the syscall instruction, but it would turn
>  > > into SIGKILL if the calling address isn't in the VSYSCALL page
>
> This will make things difficult for user-space dynamic binary instrumentation
> applications, since these normally execute generated code at different
> addresses than the original code.
>
> Is there a safe fallback for this particular vsyscall?

All of the vsyscalls have vDSO versions that work like any other code.

Alternatively, if the dynamic instrumentation code knew about
vsyscalls, it could just not instrument addresses in the vsyscall
page.

What existing applications would get broken?

--Andy
