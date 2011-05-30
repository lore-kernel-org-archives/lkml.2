Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1E3KkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:40:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47051 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1E3KkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=qWAm8ayZwYAzJWeVVdDIPfl3axpi90FrF7uGqq0Yf/GfwFMy+Q2bfgTEbn53qpg9xI
         Eu20tJXNPBjSBwvbwJCKKWjUF8RlHWrb4GVu0Mvibt06b+wfnRWPLC7Iwgc8vUKym0kl
         6TfPlfEbZRlUnEOTsajhVBXtPIRsjlJoZxVRY=
MIME-Version: 1.0
In-Reply-To: <20110530075924.GE6720@liondog.tnic>
References: <cover.1306724657.git.luto@mit.edu> <dbaa4069dec9bae213e136ff6e045236b3396b87.1306724657.git.luto@mit.edu>
 <20110530075924.GE6720@liondog.tnic>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 30 May 2011 06:40:03 -0400
X-Google-Sender-Auth: JkI0hqZz-_OkV9nj4o-KeQ7Jjzw
Message-ID: <BANLkTi=5DK7XUwQZvC8tSM4vXu5LObBHjQ@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] x86-64: Document some of entry_64.S
To: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@mit.edu>,
        Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 3:59 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, May 29, 2011 at 11:48:47PM -0400, Andy Lutomirski wrote:
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>
> Oh yeah!
>
> Acked-by: Borislav Petkov <bp@alien8.de>
>
>> +The x86 architecture has quite a few different ways to jump into
>> +kernel code.  Most of these entry points are registered in
>> +arch/x86/kernel/traps.c and implemented in arch/x86/kernel/entry_64.S
>
> and arch/x86/ia32/ia32entry.S

I was hedging by saying "most".  Will fix.

>> +
>> +There are a few complexities here.  The different x86-64 entries have
>> +different calling conventions.  The syscall and sysenter instructions
>> +have their own peculiar calling conventions.  Some of the IDT entries
>> +push an error code onto the stack; others don't.  IDT entries using
>> +the IST alternative stack mechanism need their own magic to get the
>> +stack frames right.  (You can find some documentation in the Intel
>> +SDM, Volume 3, Chapter 6.)
>
> and the AMD APM Volume 2, Chapter 8.

Of course.  I think I like that version even better.  Page 243 is a
great summary.

(And whose idea was it to have pushing the error code be optional?)


--Andy
