Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab1EaQLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:11:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33349 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab1EaQLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=m4jv5B57oE3vF8HMiixcZzJxww4KOtBEywXwch/LR+yYdrLuls53DGFpD6I4lDXymH
         PCS3ednEyP2rWEKCoXSuKNNloSPH1lrpJFPGCWk0XBk/ehO13PwhcnIASO9vFphU0khs
         DmyeFrICOqPr8j91o3sMsZgk+EfQX/Qmt40gQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTimGAtCPuvwvKfD6TLcabVzqKZhfGg@mail.gmail.com>
References: <cover.1306851090.git.luto@mit.edu> <75a00aee647302e22c86a5c5fac0478b9776481a.1306851090.git.luto@mit.edu>
 <20110531154012.GB30353@elte.hu> <BANLkTimGAtCPuvwvKfD6TLcabVzqKZhfGg@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 31 May 2011 12:10:40 -0400
X-Google-Sender-Auth: g8l_Cmufqc7dGlwykKgfqc_gtQ0
Message-ID: <BANLkTi=cV=aOZsg5D0gNQP6GOZnKwPi9tQ@mail.gmail.com>
Subject: Re: [PATCH v4 09/10] x86-64: Randomize int 0xcc magic al values at boot
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
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

On Tue, May 31, 2011 at 11:56 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> We could scrap int 0xcc entirely and emulate on page fault, but that
> is slower and has other problems (like breaking anything that thinks
> it can look at a call target in a binary and dereference that
> address).
>
> Here's a possibly dumb/evil idea:
>
> Put real syscalls in the vsyscall page but mark the page NX.  Then
> emulate the vsyscalls on the PF_INSTR fault when userspace jumps to
> the correct address but send SIGSEGV for the wrong address.
>
> Down side: it's even more complexity for the same silly case.

Scratch that.  It's incompatible with keeping time() fast for now.

>
> --Andy
>
>>
>> Thanks,
>>
>>        Ingo
>>
>
