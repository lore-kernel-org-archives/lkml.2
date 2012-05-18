Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968146Ab2ERWIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:08:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48114 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967321Ab2ERWIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:08:53 -0400
Message-ID: <4FB6C862.5060401@zytor.com>
Date: Fri, 18 May 2012 15:08:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        David Daney <ddaney.cavm@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 08/10] Use __kernel_ulong_t in struct msqid64_ds
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com> <201205182131.29353.arnd@arndb.de> <4FB6C1F7.1010307@zytor.com> <201205182158.59616.arnd@arndb.de>
In-Reply-To: <201205182158.59616.arnd@arndb.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 02:58 PM, Arnd Bergmann wrote:
> 
> But why do you think it's wrong the way it is? I see the idea of putting
> padding in varying places depending on the endianess as a failed experiment
> and defining a structure that is always the same as the logical conclusion
> from that, even if it's a bit silly to have any padding in it at all.
> 

The *whole point* is to make the structure the same across modes, to
make the compat layer's job easier.

> Being consistent seems more important here than following the intent
> of whoever came up with the concept of the ipc64 data structures
> and was consequently ignored by most people after him.

So you're saying because some architectures introduced a bug, we should
*CONTINUE* to introduce the same bug??  WTF??

> If we really wanted the data structures to be compatible between 32 and
> 64 bit mode, we'd have to use __u64 here but that would mean having to
> change all bits of user code that already rely on the existing x86
> compatible layout.

x86 is doing it right.  Some bigendian architectures blindly copied what
x86 was doing without thinking.  That's a bug on their part, period.

	-hpa


