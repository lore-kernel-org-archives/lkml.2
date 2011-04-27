Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab1D0ItW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:49:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37351 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab1D0ItT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TrXC5Zi/KJfQDkvsOab0sfr+nHcTytChYg5600rF6OQvEL1KTLhVqAAZXnbH1x2Km8
         oXYVFJ5p15AjzZKL8EcxMegB5Z95SzAgqPOc5GhL1Rls++gV7Gr+dEtkhG9DD4gD9ud3
         29g69z+QTfwOOIm0DEOUxmwqAJHhq/9XGRx0o=
MIME-Version: 1.0
In-Reply-To: <BANLkTimPJQ4QvbBVOURx_Jmuhwnf=zK9tQ@mail.gmail.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	<20110426190531.GA4556@p183>
	<1303845468.18763.32.camel@gandalf.stny.rr.com>
	<20110426192029.GA4686@p183>
	<BANLkTinxvyxSK9f+kkQugNkQEBf1O65bLQ@mail.gmail.com>
	<1303846642.18763.37.camel@gandalf.stny.rr.com>
	<1303847110.24299.50.camel@Joe-Laptop>
	<BANLkTimf44AgMAViHrSEz78ifHUYb8ji6g@mail.gmail.com>
	<1303847902.18763.38.camel@gandalf.stny.rr.com>
	<BANLkTike-s90heETJsZ+z7Kim8f-hN=UPw@mail.gmail.com>
	<BANLkTimPJQ4QvbBVOURx_Jmuhwnf=zK9tQ@mail.gmail.com>
Date: Wed, 27 Apr 2011 10:49:18 +0200
Message-ID: <BANLkTik0vZC6afD_hrRQxpq6xOk-Ma0tMA@mail.gmail.com>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thiago Farina <tfransosi@gmail.com>,
        Joe Perches <joe@perches.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:42 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Wed, Apr 27, 2011 at 10:29, Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
>> On Tue, Apr 26, 2011 at 9:58 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>> On Tue, 2011-04-26 at 16:47 -0300, Thiago Farina wrote:
>>>
>>>> > $ grep -rP --include=*.[ch] "\bstrcmp.*==\s*0\b" * | wc -l
>>>> > 1143
>>>> > $ grep -rP --include=*.[ch] "\!\s*strcmp\s*\(" *  | wc -l
>>>> > 1663
>>>> >
>>>> > Can you count how many misuses of strcmp have been
>>>> > corrected?
>>>>
>>>> > Do you plan to convert the existing 2800?
>>>>
>>>> I'd work on this without any problem.
>>>
>>> Nothing a perl script can't do either.
>>
>> If you are really going to do that, please use a coccinelle's semantic
>> patch (which is designed precisely for that purpose) and document it
>> so that it can be included in the standard set of semantic patches
>> applied to the kernel regularly, i.e. something like:
>
> First, I agree (mildly) with the opponents: strcmp() is standard C99.
> Second, as the goal is to avoid bugs, this conversion should not be blindly
> done by a script and be done with it, but reviewed by a human.

Hi, on the contrary: I don't agree with the change unless a policy for
all this kind of changes (i.e. changes which diverge from C99) is
written and discussed first for all the kernel (and not only in
strcmp's regard). I was just warning about the potential size of the
patch (like Ted Ts'o did) and the dangers of doing it with a quickly
hacked perl script. Using a coccinelle semantic patch would much
better suited for this and less error prone if this kind of changes
are ultimately merged.

Regards,
Miguel Ojeda

>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
>
