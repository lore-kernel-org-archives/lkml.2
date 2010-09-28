Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab0I1Rg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:36:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34706 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab0I1Rgz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:36:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=T3ibTY0106i6mVMpQEsMFUdY6fijc+UqpOObPGj/s2Dv4JovfG9Pa81EgWJdIKwbNr
         uiE/nWjSlFbrE82wubmdgqcYm5J84fPnbN/Ml//4NZGXyTR5YlA6ZfNfagdOR2GptTSV
         2TB2F5XjiAr6va1Mev32KQUIaY5+sX1c6JtgA=
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <4CA1E809.5010103@tilera.com>
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com>
 <201009281040.09728.arnd@arndb.de> <4CA1E809.5010103@tilera.com>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Tue, 28 Sep 2010 12:36:33 -0500
Message-ID: <AANLkTik4K+P_3pzN3g4_1UBnOVWTHLmRwFoHLKOS018T@mail.gmail.com>
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>, GLIBC Devel <libc-alpha@sourceware.org>,
        linux-kernel@vger.kernel.org, libc-ports@sourceware.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On 28 September 2010 08:05, Chris Metcalf <cmetcalf@tilera.com> wrote:
>  (Adding libc-ports to the cc list.)
>
> On 9/28/2010 4:40 AM, Arnd Bergmann wrote:
>> Chris Metcalf is using the generic unistd.h file on the tile architecture
>> and has a glibc port that should be easily portable to all future
>> architectures. There are a few of them getting ready to be merged
>> now (c6x, lm32, nios2, and some people have contacted me privately
>> for architectures I cannot name).
>>
>> I expect that all of them will just use the same syscall ABI and glibc
>> port.
>
> I'm happy to provide some previews of the work I'm doing to interested parties.

Yes, this is exactly what I'm looking for!  I'd love to "preview" the
code; it'll take a good long while to get everything built and tested,
so feeback might take a while ...

Any chance that these could be split out as a distinct set of patches,
taken apart from the tilera arch port, and submitted upstream
independently (to glibc and/or ports collection)?  I'll help w/ patch
preparation...

> I have a few patches for the platform-independent glibc code, mostly for
> things which are exposed in our platform but not in others.  E.g.
> __readlink() in include/unistd.h returns the wrong type (int not ssize_t),
> and some of the standard Linux implementations of things like fxstat64.c
> need to be completely wrapped with "#ifndef XSTAT_IS_XSTAT64" so that
> fxstat.c can provide the alias, since all the stat structures are the same
> everywhere.  I will submit some separate patches to libc-alpha for this.

Yes, I presume that arch-indep fixes can/should be submitted even
before a port is ready.  I do notice that the glibc maintainers can be
somewhat reticent of accepting these, for fear of accidentally breaking
working code.

-- Linas
