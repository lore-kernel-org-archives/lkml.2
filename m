Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1HaU7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:59:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58037 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab1HaU7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:59:39 -0400
Message-ID: <4E5EA068.9070206@zytor.com>
Date: Wed, 31 Aug 2011 13:58:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <20110831205439.1a0c94da@lxorguk.ukuu.org.uk> <4E5E9347.4010503@zytor.com> <2902501.mMiynrre7t@wuerfel>
In-Reply-To: <2902501.mMiynrre7t@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 01:55 PM, Arnd Bergmann wrote:
> 
> But isn't this mostly a glibc thing then? The definition of time_t that
> is used by applications comes from bits/typesizes.h, not from the
> kernel's linux/types.h. If we use 64 bit time_t values internally
> in the kernel and truncate them to 32 bits on the user interface,
> there is no visible difference between signed and unsigned values
> for data passed from kernel to user when it's interpreted as
> signed int anyway.
> 
> For the rarer case of user space passing a 32 bit time_t into the
> kernel (e.g. utimensat), there is of course a difference.
> 

Yes, exactly.  It should be done in a coordinated fashion.

	-hpa
