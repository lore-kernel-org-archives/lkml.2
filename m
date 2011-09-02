Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab1IBAtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 20:49:16 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:54275 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab1IBAtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 20:49:14 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFD: x32 ABI system call numbers
Date: Fri, 2 Sep 2011 01:49:10 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
Cc: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
References: <4E582577.2060805@zytor.com> <4E5F88F8.2040008@redhat.com> <4E5F930A.6070006@zytor.com>
In-Reply-To: <4E5F930A.6070006@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109020149.10780.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 September 2011 15:13:30, H. Peter Anvin wrote:
> On 09/01/2011 06:30 AM, Avi Kivity wrote:
> > On 08/31/2011 08:09 PM, H. Peter Anvin wrote:
> >>>  I really think that "x32" should try to aim *VERY* hard at using the
> >>>  64-bit system calls, and seeing itself as being a "32-bit application
> >>>  in a 64-bit world".  That's not just true for time_t (which I think
> >>>  should be 64-bit on anything new that expects to survive for any
> >>>  amount of time), but in general.
> >>
> >> We're trying for it.  The things we're trying to avoid is to muck (too
> >> much) with the compat layer for the mega-multiplex system calls like
> >> ioctl.  We can't just use the 64-bit ioctl because ioctl structures
> >> generally contain pointers.
> >>
> > 
> >      struct iovec
> >      {
> >          void __user *iov_base;    /* BSD uses caddr_t (1003.1g requires 
> > void *) */
> >          __kernel_size_t iov_len; /* Must be size_t (1003.1g) */
> >      } __attribute__((x32_abi_64));
> > 
> >      typedef long time_t __attribute__((x32_abi_64));
> > 
> > The x32_abi_64 attribute converts pointers and longs back to 64-bit and 
> > adjusts the alignment accordingly.  If we tag all userspace visible 
> > structures with this attribute, we can use the 64-bit ABI without changes.

I would expect no new gcc extension to be needed for that -- there's the
mode attribute (you can read DI as 64-bit):

 typedef void * __kernel_ptr64 __attribute ((mode(DI)));

 struct iovec
 {
   __kernel_ptr64 iov_base;
   ...
 };

-- 
Pedro Alves
