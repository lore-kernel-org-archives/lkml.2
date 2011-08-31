Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1HaU4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:56:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52137 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab1HaU4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:56:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
Date: Wed, 31 Aug 2011 22:55:31 +0200
Message-ID: <2902501.mMiynrre7t@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <4E5E9347.4010503@zytor.com>
References: <4E582577.2060805@zytor.com> <20110831205439.1a0c94da@lxorguk.ukuu.org.uk> <4E5E9347.4010503@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:xGuATZU5TyNpLE9xBo/Q7PZcXckDoVrHaUvzFgYiq6G
 oqSe0cnIqN2y/k6ItJTQEjR0YC/jQXfJSHV2iEZX8jgoG9rmEP
 20xWx8UMsefIVAO+IZZyj2PJaz6vDmfYpMS+8BW6vRoONaLNe3
 a2t9BYh6F19sXq+F2CnU8YB85RZpNt+BDEx/+ysrPt5svRKYsB
 Q5iKiXKsSSnYkgNB2BlKZ/4nvTWDUtAPfEDl2NrWjIqmqLxMK2
 VlFwr1nlLVzRlMD4AttJsn8ZWvkoEgZeNBI5/NoU8DncAxauzm
 7dP9qDjhPUHJ/2ZLm6lCtTXsV0v69o6VaeeMFYK0v0HUZ5hsR/
 leDfq9Tu2onxJZRiaoiM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 August 2011 13:02:15 H. Peter Anvin wrote:
> On 08/31/2011 12:54 PM, Alan Cox wrote:
> >>
> >> The only reason I mentioned redefining 32-bit time_t as unsigned was for
> >> *legacy ABIs*.
> > 
> > But if you redefine it then it's not a legacy ABI any more - its a new
> > ABI.
> 
> Only sort-of-kind of.  It's like hacking around the Y2K problem by date
> windowing; it technically it is an ABI change but when it is going to
> break anyway...

But isn't this mostly a glibc thing then? The definition of time_t that
is used by applications comes from bits/typesizes.h, not from the
kernel's linux/types.h. If we use 64 bit time_t values internally
in the kernel and truncate them to 32 bits on the user interface,
there is no visible difference between signed and unsigned values
for data passed from kernel to user when it's interpreted as
signed int anyway.

For the rarer case of user space passing a 32 bit time_t into the
kernel (e.g. utimensat), there is of course a difference.

	Arnd
