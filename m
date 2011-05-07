Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab1EGIeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 04:34:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52106 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1EGIe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 04:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DMlMOZXlQexh0YF3WXzOm93Jm6jCF+FlQ/4Ry4tKOmjwXRVXFV/mDIpivj8MHZFMg0
         Wpmd2mXwuUytavem2H16qmHnlKRW5UTG23Md7PuKMuIaHXPrSNB5v9xMWrJz7RDlKMW7
         tTNqGoX4JaeZiobIbV2pheUkZgyzOk5EsXqho=
MIME-Version: 1.0
In-Reply-To: <19907.2804.330120.193924@pilspetsen.it.uu.se>
References: <alpine.DEB.2.00.1105042033190.9040@ayla.of.borg>
	<201105050824.34056.arnd@arndb.de>
	<alpine.DEB.2.00.1105052042590.17077@ayla.of.borg>
	<19907.2804.330120.193924@pilspetsen.it.uu.se>
Date: Sat, 7 May 2011 10:34:25 +0200
X-Google-Sender-Auth: EWoABWuz6iuTuueM_f4IjuvRUyU
Message-ID: <BANLkTinssNTc_+=F4CA1Znb3bdv=c30OPw@mail.gmail.com>
Subject: Re: [PATCH] m68k: Merge mmu and non-mmu versions of sys_call_table
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Arnd Bergmann <arnd@arndb.de>, "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 5, 2011 at 22:39, Mikael Pettersson <mikpe@it.uu.se> wrote:
> Geert Uytterhoeven writes:
>  > On Thu, 5 May 2011, Arnd Bergmann wrote:
>  > > Did you check the macros in unistd to see if they match the
>  > > actual table? I guess it would be a good time to comment out
>  > > the ones that are not implemented in either of the two ABIs.
>  >
>  > Like this?
>  >
>  > warning: #warning syscall pselect6 not implemented
>  > warning: #warning syscall ppoll not implemented
>  > warning: #warning syscall recvmmsg not implemented
>  >
>  > Do we need pselect6 and ppoll? I have vague memories not requiring it.
>
> They close user-space race conditions, so you want them.

So do you recommend to backport the wiring up of pselect6/ppoll to -stable?
We always had their _NR_* defines, so I guess glibc was always compiled
with pselect6/ppoll support, and will use it if it's present.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
