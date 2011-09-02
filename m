Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab1IBIFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 04:05:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab1IBIFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 04:05:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pedro Alves <pedro@codesourcery.com>, Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
Date: Fri, 02 Sep 2011 10:02:38 +0200
Message-ID: <3265903.Gp9iD1LkVC@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <4E6036A7.6090200@zytor.com>
References: <4E582577.2060805@zytor.com> <201109020149.10780.pedro@codesourcery.com> <4E6036A7.6090200@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:epATdrojZfwBBGC1KHE0XASegbMND5mkLyRDpPObSDm
 7tTafn7TnVq/yqxTp7ZZTiq9PVm4+OE0ss0cejXymgDYvndu33
 BL2APpXbmhHgxHvA/OSkWTUTizzwg8LJdg/03g1t5nbQJD6/D1
 Zw3R1lUG/SSHNp2tMbd5tf274ipx1xR85u+ko25xEx0s6fSIlP
 ptuG6qk996gLLS32weiRgDT9ZFhrsFzzL9UqGk++qXwqz8okCE
 5TnDpocR+/pV8dhQjdPz43WT5Q5Y3V7adFqRYlEP//J+Ah+L+z
 Vj/Hkjl1wzzuGNSZ9TgbxmbqOX8Bspy1KMjQZ6+L7OCAnxCkdl
 E6Q6PlwHATd+9SzQVGIE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 September 2011 18:51:35 H. Peter Anvin wrote:
> On 09/01/2011 05:49 PM, Pedro Alves wrote:
> >>>
> >>>       struct iovec
> >>>       {
> >>>           void __user *iov_base;    /* BSD uses caddr_t (1003.1g requires
> >>> void *) */
> >>>           __kernel_size_t iov_len; /* Must be size_t (1003.1g) */
> >>>       } __attribute__((x32_abi_64));
> >>>
> >>>       typedef long time_t __attribute__((x32_abi_64));
> >>>
> >>> The x32_abi_64 attribute converts pointers and longs back to 64-bit and
> >>> adjusts the alignment accordingly.  If we tag all userspace visible
> >>> structures with this attribute, we can use the 64-bit ABI without changes.
> >
> > I would expect no new gcc extension to be needed for that -- there's the
> > mode attribute (you can read DI as 64-bit):
> >
> >   typedef void * __kernel_ptr64 __attribute ((mode(DI)));
> >
> >   struct iovec
> >   {
> >     __kernel_ptr64 iov_base;
> >     ...
> >   };
> >
> 
> Does that work for *writing*, too?  That might be a very useful little 
> escape hatch for some particularly tight corners.

I've tried to use that extension in other contexts without much success,
mostly I believe because gcc back-end support for it needs to be there
but wasn't at the time I tried. If the x32 back-end does this correctly,
you win.

A different gcc extension that might turn out to be useful here is the
named address space extension that lets you annotate a pointer to
be different from other pointers. On the SPU architecture we use this
for the destinction between local 18 bit pointers and 64-bit pointers
into the user process address space.

	Arnd
