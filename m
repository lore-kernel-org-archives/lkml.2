Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2IYRLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:11:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59319 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab2IYRLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:11:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Subject: Re: [PATCH v2] hvc_dcc : add support to armv4 and armv5 core
Date: Tue, 25 Sep 2012 15:44:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Matthieu CASTET <castet.matthieu@free.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
References: <1346413645-4593-1-git-send-email-castet.matthieu@free.fr> <201209031257.28213.arnd@arndb.de> <5061CF5A.2030201@parrot.com>
In-Reply-To: <5061CF5A.2030201@parrot.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209251544.57998.arnd@arndb.de>
X-Provags-ID: V02:K0:GiszXjnsvJE9SRDg4Nbvp9w6/Mk9FK21AOdCb6HDUgx
 1ru1uVrFXGTCYy4Z55ijY0HBWM3Pb2cuKlmfEPhfI0faJT0e+E
 Vtxy82rS+wfuzoHxV69q85KJ9Ud2xCCL3DRZ7I77bSJc/XGk4S
 rz9fU5okUGnMMN2R7NLtfHGaEe6YlflYWRcHQZg3So73EnG01L
 NQISWaqGaCBnGml1tK+xkKmEevJ/ZdGfolx9bqX44a8hKkEvEq
 KFG9j8TnmNhp5Mm0ynsP0R+izScDQ2uXFm1iM5XIMgutaPdihf
 BGvNUkjtnSotsCANnvZjG7qUkf1++h0d8NVvqTKF0mwmZ3Kj7/
 NvhCPW6yPLBRG0tKn+D0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2012, Matthieu CASTET wrote:
> > static inline char __dcc_getchar(void)
> > {
> >         char __c;
> > 
> >         if (__LINUX_ARM_ARCH >= 6)
> >               asm volatile("mrc p14, 0, %0, c0, c5, 0 @ read comms data reg"
> >                       : "=r" (__c));
> >       else
> >               asm volatile ("mrc p14, 0, %0, c1, c0  @ read comms data reg"
> >                       : "=r" (ret));
> >         isb();
> > 
> >         return __c;
> > }
> > 
> >       Arnd
> > 
> Yes doing that will be great!
> 
> But Alan wanted "all be runtime handled".
> 
> May be we can do something like:
> 
> 
> static int cpu_arch;
> 
> static inline char __dcc_getchar(void)
> {
>          char __c;
> 
>          if (cpu_arch >= 6)
>                 asm volatile("mrc p14, 0, %0, c0, c5, 0 @ read comms data reg"
>                         : "=r" (__c));
>         else
>                 asm volatile ("mrc p14, 0, %0, c1, c0  @ read comms data reg"
>                         : "=r" (ret));
>          isb();
> 
>          return __c;
> }

It's not possible to build a kernel that runs on ARMv5 (or below) and also on
ARMv6 (or above), so the effect would be exactly the same. While we are putting
a lot of effort into making all sorts of ARMv6 and ARMv7 based systems work
with the same kernel binary, it's highly unlikely we would ever need the
above to be runtime selected, because there are a lot of other differences
at assembly level.

	Arnd

