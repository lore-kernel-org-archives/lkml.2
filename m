Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab1EWP23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:28:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46840 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab1EWP21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=H/3wAzwEmeboYbv84PrFpanueqVZQMNdrfFcGwWJ87xeRLg/YQotHz7WlhPUrT3azq
         Z7/e+LXogofNKL1MeITN6xvA0Mrb8w5qQypD16VQblx8uOlw2pQjbyGv3wdqLrty/xBX
         kcIdm6shNN9lpf/8vEdOjieYAMUelnHunA6ww=
MIME-Version: 1.0
In-Reply-To: <BANLkTinxLPj-S82axeG6JHvM54hGfMt=9w@mail.gmail.com>
References: <cover.1306156808.git.luto@mit.edu> <BANLkTinxLPj-S82axeG6JHvM54hGfMt=9w@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 23 May 2011 11:28:07 -0400
X-Google-Sender-Auth: 2xLusduewMy1Wc2QiufWM-m4ATg
Message-ID: <BANLkTikHTLGnbY++=MmAwEoi8yLiNAdemA@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] vDSO time changes for 2.6.40
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 11:23 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, May 23, 2011 at 6:31 AM, Andy Lutomirski <luto@mit.edu> wrote:
>> [Patch 8/8 is brand-new and optional.  If anyone objects to it,
>>  please just drop it for 2.6.40 and I'll fix it for 2.6.41.]
>
> Hmm. I would just put it into 7/8 immediately, and never have the
> stupid read-lock loop in the first place.
>
> Or I would just say "the time() system call just isn't that critical,
> let's not even bother".

I have no particular preference.  The only argument I can make is that
the change deletes code and it lets us tell the glibc people "not only
can you stop using a silly old interface but you can make your code
0.4ns faster."

--Andy
