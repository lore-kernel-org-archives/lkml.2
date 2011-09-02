Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab1IBBxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 21:53:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43468 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021Ab1IBBxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 21:53:13 -0400
Message-ID: <4E6036A7.6090200@zytor.com>
Date: Thu, 01 Sep 2011 18:51:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Pedro Alves <pedro@codesourcery.com>
CC: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <4E5F88F8.2040008@redhat.com> <4E5F930A.6070006@zytor.com> <201109020149.10780.pedro@codesourcery.com>
In-Reply-To: <201109020149.10780.pedro@codesourcery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2011 05:49 PM, Pedro Alves wrote:
>>>
>>>       struct iovec
>>>       {
>>>           void __user *iov_base;    /* BSD uses caddr_t (1003.1g requires
>>> void *) */
>>>           __kernel_size_t iov_len; /* Must be size_t (1003.1g) */
>>>       } __attribute__((x32_abi_64));
>>>
>>>       typedef long time_t __attribute__((x32_abi_64));
>>>
>>> The x32_abi_64 attribute converts pointers and longs back to 64-bit and
>>> adjusts the alignment accordingly.  If we tag all userspace visible
>>> structures with this attribute, we can use the 64-bit ABI without changes.
>
> I would expect no new gcc extension to be needed for that -- there's the
> mode attribute (you can read DI as 64-bit):
>
>   typedef void * __kernel_ptr64 __attribute ((mode(DI)));
>
>   struct iovec
>   {
>     __kernel_ptr64 iov_base;
>     ...
>   };
>

Does that work for *writing*, too?  That might be a very useful little 
escape hatch for some particularly tight corners.

	-hpa
