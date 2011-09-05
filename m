Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab1IEHsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 03:48:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50056 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1IEHsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 03:48:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
Date: Mon, 05 Sep 2011 09:48 +0200
Message-ID: <2722845.TegCUU4bu0@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <CAMe9rOrU0wcrRxPoTRcmVRd+2hDwjCta_73Ji-MMiRRXR-3ndw@mail.gmail.com>
References: <4E582577.2060805@zytor.com> <3634139.5BAXH7nXYb@wuerfel> <CAMe9rOrU0wcrRxPoTRcmVRd+2hDwjCta_73Ji-MMiRRXR-3ndw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vFN7GyTiRsE0k1pnb0VwJ6vyu5kInNbFgCgC6hRbezG
 bluBis32Jcvx+V4DqcszpW2LlITOh5OELWYjw22T/lN3gDWDKG
 LpcBfIFRt8rZnzum4o0FNohWCu8CEkSG15iFi9bnD7mBrPlVPW
 4bB+jHRMbQV8AooGado72ylrWwJAeMKLvi/vXKde31KZsmxddB
 HphYZ4zYOqj6TwuLApau21ftGldOHOpMzk9BN9Nqd8K4KYPsIR
 G6lFYAB884wB+4moTRenDTVkUH+pw3sFJNc2VDj6Qv4sggG5Td
 nxTuXaibodRHz1Y+CR3rW/mQda/o3mLrpUNQDBBPgrqr6fm31K
 UjYIh/0qokDI5qdM2KyU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 September 2011 15:13:18 H.J. Lu wrote:
> On Sun, Sep 4, 2011 at 2:41 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Sunday 04 September 2011 14:25:53 H.J. Lu wrote:
> >> >> >> #define __NR_x32_recvfrom
> >> >> >> #define __NR_x32_sendmsg
> >> >> >> #define __NR_x32_recvmsg
> >> >> >> #define __NR_x32_recvmmsg
> >> >> >> #define __NR_x32_sendmmsg
> >> >> >
> >> >> > These today use the MSG_CMSG_COMPAT flag to distinguish native and compat
> >> >> > calls. Do you plan to have another flag here to handle cmsg time values?
> >> >>
> >> >> I am using x86-32 calls for them.
> >> >
> >> > But isn't that broken? These all pass u64 or time_t values at some point.
> >> >
> >>
> >> time_t isn't a problem since time_t/timeval/timespec are identical for
> >> x32 and x86-64.  As for u64, I added NATIVE_LONG_TYPE, which is
> >> defined as long long for x32,  and use it instead of long in types for
> >> 64bit system calls.
> >
> > Sorry, I misread you as saying you use the compat syscalls for these.
> > If you use the native 64 bit syscalls, you have the opposite problem:
> > Some network protocols (e.g. netlink or rxrpc) use other data structures
> > that require conversion, e.g. 'long' members that x32 will get wrong.
> 
> For those, I use x86-32 calls.

So to ask again, what do you plan to do about SCM_TIMESTAMP*?

	Arnd
