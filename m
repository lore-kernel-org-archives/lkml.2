Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab1EYNAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:00:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55874 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab1EYNAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Lx9+YsvB7n1GaLG/7uQw1d4LXVf0hJCj4vpFKSX/WDdrohRB1eYvHJRicUP5UhHZUF
         wE7h3R10XcdYWnIVaMCp7G5V/CcR376kxgM3R+b0Twtmjaeehrc5u9PquKuW1HKlvJYj
         MtiLCEQEV0wPFG4LPoP+QOymCLW/VYqxhY5zg=
MIME-Version: 1.0
In-Reply-To: <20110525124741.GC29300@elte.hu>
References: <m11uzrvd26.fsf@fess.ebiederm.org>
	<BANLkTim4q5dK6nOb=pVKbk1c8b-Nh_hBfA@mail.gmail.com>
	<m1boyvpo9r.fsf@fess.ebiederm.org>
	<1306048393.4092.8.camel@mulgrave.site>
	<20110522084224.GA12279@elte.hu>
	<m1k4dgr35i.fsf@fess.ebiederm.org>
	<20110524071628.GA31612@elte.hu>
	<4508.1306283693@localhost>
	<20110525082514.GE21552@elte.hu>
	<BANLkTikVDrU7Nx6143gPuB=1vwqkMFiRiQ@mail.gmail.com>
	<20110525124741.GC29300@elte.hu>
Date: Wed, 25 May 2011 15:00:30 +0200
X-Google-Sender-Auth: HMhgE7zmynQPdXE8wPHqLiMSlT8
Message-ID: <BANLkTimQcyX9XSY__9Bpg3tg7-P7gtOTkw@mail.gmail.com>
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Valdis.Kletnieks@vt.edu, "Eric W. Biederman" <ebiederm@xmission.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 14:47, Ingo Molnar <mingo@elte.hu> wrote:
> * Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
>> > But at least the primary, 'native' syscall table of every arch
>> > could be kept rather fresh via generic enumeration.
>>
>> So we can start all over at offset 501 (alpha just started using
>> 500) with a unified, clean, and compressed list of syscalls? Or do
>> we have some more other-os-compat syscalls around in this range?
>
> No, that would leave a big hole in the syscall table of most
> architectures.

Sure, but we could (a) optimize for the case where the syscall number is
larger than 500 and/or (b) drop support for syscall numbers smaller than
501, depending on a config option.

> So what would be needed is for each architecture to define a 'generic
> syscall table base index', ARCH_SYSCALL_BASE or so, and the generic
> syscalls would be added for that.
>
> Alpha would have 501, the others lower numbers.
>
> The only general assumption we can rely on is that there's a range of
> not yet used syscall numbers starting at the end of the current
> syscall table.

Yep, that would work too.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
