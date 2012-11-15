Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993460Ab2KOOhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:37:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61019 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993437Ab2KOOhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:37:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: new architectures, time_t __kernel_long_t
Date: Thu, 15 Nov 2012 14:36:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        Vineet.Gupta1@synopsys.com, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>
References: <201211141218.02105.arnd@arndb.de> <201211150914.22835.arnd@arndb.de> <CAMe9rOpziKa6QLfjX9iXtfj_X2QAyDAV2p8NEd8Wd7yFwTrpNg@mail.gmail.com>
In-Reply-To: <CAMe9rOpziKa6QLfjX9iXtfj_X2QAyDAV2p8NEd8Wd7yFwTrpNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211151436.23088.arnd@arndb.de>
X-Provags-ID: V02:K0:OXB0rr7TdV45BlOfADa/KBvhP0SWWWMbIn6MCypJK3P
 W8+0FLiXDTKa+Z0PFdv9hm4AimvcvRLDAnZX0VFBUTdPIupvev
 9EBh7fr1aIrGuxcOdKEMZSyhvwJ/ZhXr7Lbf16If5oHd9i8T6a
 7SuvKdmfh3Wv8P2u8XdRAt/2QBcvZK64DWXtob+4c1bmU90C7f
 6jGZqkDYnOdOeXjVr/QerWo3TAvXsrpG9iZEqjmiemdPvdq2mZ
 pc5QjtDdFDlf00Y8/nnoBZykQUbtwe03lMvRtfvj+MkmvPlb7H
 eoslLimGzBECgzeGX+Auf0yguB/8TokNKA77EJKDnA5z0QnkLs
 BLF3oE35pUcRU+O8VO10=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012, H.J. Lu wrote:
> On Thu, Nov 15, 2012 at 1:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 14 November 2012, H. Peter Anvin wrote:
> >> On 11/14/2012 04:18 AM, Arnd Bergmann wrote:
> >> > Since we are in the review phase for two new architectures that we
> >> > should be merging into the mainline kernel, I think we need to
> >> > come up with a solution for making them use a proper 64-bit time_t.
> >> >
> >> > Right now, the only 32-bit user space interface we have to use 64-bit
> >> > time_t is the x32 side of x86-64, and that works by overriding all
> >> > "long" sized types to be 64 bit at the ABI level, which we don't
> >> > want for pure 32 bit architectures.
> >>
> >> Sort of.  Either way, the kernel headers aren't really x32-clean yet, so
> >> we have an opportunity to do things more cleanly as we are implementing
> >> this.
> >
> > Ah, I didn't know that. How does one build an x32 libc then?
> 
> Glibc has been providing its own types for years.
> Kernel provided types used to be wrong for ia32
> on x86-64.

What about ioctls and other calls then that actually do rely on the
kernel headers and use the __kernel_*_t types?

	Arnd
