Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1EaNSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:18:03 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51396 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1EaNR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:17:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=xyeHy7E/HkRyWdQGRLTL2mJt3e8GRCyBVtUmmZ9LsEuhjDcSjgC1a7HNqwWQECaEYD
         X1LmbIs6+Jb8Qf7ammmRTH2+xTH9ySiYTaWYlzD8HwR0b9qGC0Jpszg9x1GSQLs1zLzr
         fAFVDCUF3ld7xpFrokGohSSWzUWD2V0VXfIW0=
MIME-Version: 1.0
In-Reply-To: <20110531131117.GB13888@elte.hu>
References: <cover.1306517576.git.luto@mit.edu> <20110529191924.GD9835@elte.hu>
 <BANLkTin9xfS_X9Bscf1qnNZMK=JBgpzV8Q@mail.gmail.com> <20110531080758.GA24172@elte.hu>
 <BANLkTi=Gi_0Uyj+dA6GjriRU9fCzKuLU=g@mail.gmail.com> <20110531125415.GD10249@elte.hu>
 <BANLkTinqGUoFTp3YcuUTAPUOUwBCQaw07g@mail.gmail.com> <20110531131117.GB13888@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 31 May 2011 09:17:39 -0400
X-Google-Sender-Auth: M2EbOOCz5RWAGuJfaVL-kUfjBgg
Message-ID: <BANLkTimqf7HY9AnMDjPr197m4LrA4qJNkg@mail.gmail.com>
Subject: Re: [PATCH 0/5] x86-64: Remove syscall instructions at fixed addresses
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 9:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>> > You could start with picking the more compatible alternative
>> > instruction initially. I don't at all mind losing half a cycle of
>> > performance in that case ... this code should be secure first.
>>
>> The more compatible one is mfence, which in some cases could (I
>> think) be a lot more than half a cycle.
>
> I'd still suggest to do the mfence change now and remove the
> alternatives patching for now - if it's more than half a cycle then
> it sure will be implemented properly, right?

I don't know.  I just cut 5 ns off the thing a couple weeks ago and no
one beat me to it :)

I'll take a look at how hard the patching will be.

--Andy

>
> Thanks,
>
>        Ingo
>
