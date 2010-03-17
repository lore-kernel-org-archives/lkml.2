Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab0CQJDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 05:03:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46415 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab0CQJDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 05:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=eR+Tq4pLFL3hY0ABb59H8xmDjPG8bPFhUJUSnjcI+ahTJ2pIcMBkBtQpV98/Wfr3G2
         XTstvgeZy6Rar3n5v1T5eGY65Ks6IQX+ZcioEpRXoXLuNrz5qNem9ERcz51IkT/e+02D
         GmY/UdEjdyhV31k3GYsNoMWSznPdrgrlUCzVw=
From: "Will L Givens" <wlgivens@gmail.com>
To: "'Michael Cree'" <mcree@orcon.net.nz>,
       "=?iso-8859-1?Q?'Ra=FAl_Porcel'?=" <armin76@gentoo.org>
Cc: "'Matt Turner'" <mattst88@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-alpha@vger.kernel.org>
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com> <4B9FDD4E.8080607@gentoo.org> <4BA085EE.3060700@orcon.net.nz>
In-Reply-To: <4BA085EE.3060700@orcon.net.nz>
Subject: RE: Will's kernel compilation error
Date: Wed, 17 Mar 2010 03:55:54 -0500
Message-ID: <009501cac5af$a757d3a0$f6077ae0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcrFpDutRG+Oeyc+TeKs9zULWA5EVQABljnw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Michael Cree [mailto:mcree@orcon.net.nz]
> Sent: Wednesday, March 17, 2010 02:34
> To: Raúl Porcel
> Cc: Matt Turner; Will L Givens; linux-kernel@vger.kernel.org; linux-
> alpha@vger.kernel.org
> Subject: Re: Will's kernel compilation error
> 
> On 17/03/10 08:34, Raúl Porcel wrote:
> > Have one.
> >
> > My error is as follows:
> >
> > net/built-in.o: In function `svc_auth_unregister':
> > (.text+0xb822c): relocation truncated to fit: GPREL16 against `.sbss'
> 
> Right, I've confirmed that with the supplied config.  What's happening
> is that the small data area (where certain static data are stored) has
> exceeded 64kB which is the limit under the small data model.  As noted
> elsewhere on this thread it can be solved by compiling with the large
> data model, but that incurs extra CPU instructions whenever the data
> area is accessed.
> 
> A better solution, in my view, is to concert some drivers to modules.
> I
> note that the config has a large number of devices to be built (some of
> which are denoted as having been tested on x86/x86_64/ia64 only).  I
> converted a few drivers, and most of the selected filesystems (do you
> really need them all at boot time?) into modules.  The kernel then
> builds correctly.
> 
> But if people insist on being able to build impractical monolithic
> kernels on Alpha I will post my patch to add a kernel option for the
> large data model.
> 
> Cheers
> Michael.

Well a monolithic kernel, which mine isn't, actually runs faster than a
modular one despite being larger... that's been proven several times over
the years. In the past I used to roll monolithic kernels simply for
emergency boot situations and because kernel modules were notorious for not
compiling properly with all kinds of undefined symbols... rolling them into
the kernel was a quick fix. Do you honestly believe all those different
modules, written by a slew of different people, will build properly let
alone function properly? Kernel-2.6.34-rc1 is the FIRST one that I've seen
where the netfilter modules all compiled!

Another thing, some components 'have' to be built into the kernel because
they won't automatically load or the kernel config makes it mandatory. The
auto load function of past kernels has been pretty iffy at best and granted
I've yet to actually load this release, I do have my doubts. So important
things such as my aic7xxx drivers, ali drivers, 751 chipset, etc. I roll
into the kernel itself.

The things that you've stated I can understand but on when you get right
down to it, it's not a major issue. My 'monolithic' kernel is only 1.9MB @
89MB/s. Personally I feel they should make small-data an patch addon, it
would save a lot of people a some grief. Some ppl will select them (modules)
either intentionally or by accident and the majority of folks are not
running AT HDD's on a flaky IDE controller. Sincerely Will L G

PS Whatever you guys decide please make it obvious... the aboot/kernel
change a few years ago, caused a lot of Alpha Linux users to bug out...
About the only ppl aware of the change was Ivan and a handful of Debian
folks.


