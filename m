Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab1DLBYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 21:24:12 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:58176 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab1DLBYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 21:24:10 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
References: <003f01cbf81a$f48cfdf0$dda6f9d0$@mprc.pku.edu.cn> <201104111724.57607.arnd@arndb.de>
In-Reply-To: <201104111724.57607.arnd@arndb.de>
Subject: RE: about __BITS_PER_LONG
Date: Tue, 12 Apr 2011 09:24:02 +0800
Message-ID: <004901cbf8b0$4eec1b60$ecc45220$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHoDOtEqkFOb2T+ICy/a2GvGMw9bgH50S9GlBFwZMA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, April 11, 2011 11:25 PM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org
> Subject: Re: about __BITS_PER_LONG
> 
> On Monday 11 April 2011, Guan Xuetao wrote:
> > --- a/include/asm-generic/bitsperlong.h
> > +++ b/include/asm-generic/bitsperlong.h
> > @@ -9,7 +9,11 @@
> >   * to decide it, but rather check a compiler provided macro.
> >   */
> >  #ifndef __BITS_PER_LONG
> > -#define __BITS_PER_LONG 32
> > +#   ifdef CONFIG_64BIT
> > +#      define __BITS_PER_LONG 64
> > +#   else
> > +#      define __BITS_PER_LONG 32
> > +#   endif /* CONFIG_64BIT */
> >  #endif
> >
> 
> Unfortunately, this does not work, because the __BITS_PER_LONG definition is meant
> for user space. You have to make this depend on a preprocessor macro that
> is provided by the compiler based on the command line switches (e.g. -m64) that
> a use could pass to the compiler.
However,  there is no conflict between the definition depending on a preprocessor macro and 
the definition of asm-generic header.

> 
> In user space, the CONFIG_* symbols are meaningless.
Yes, that's the problem. I have not notice it before.
So, only one value can be reserved in such circumstances.

> 
> 	Arnd

Thanks & Regards.

Guan Xuetao

