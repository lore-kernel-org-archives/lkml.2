Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0IMP6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:58:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41018 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab0IMP6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:58:22 -0400
Message-ID: <4C8E49B7.7040104@zytor.com>
Date: Mon, 13 Sep 2010 08:56:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: florian@mickler.org, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: don't compile with gcc-3.3.3
References: <1284366708-30154-1-git-send-email-florian@mickler.org> <1284367195.2275.29.camel@laptop>
In-Reply-To: <1284367195.2275.29.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2010 01:39 AM, Peter Zijlstra wrote:
> On Mon, 2010-09-13 at 10:31 +0200, florian@mickler.org wrote:
>> hpa commented on bug 16506[1] :
>> "Please note that gcc-3.3.3 is known broken on x86; gcc-3.4 is the oldest
>> version which is known to *not* be broken."
>>
>> References: 
>> 	[0]: https://bugzilla.kernel.org/show_bug.cgi?id=16633
>> 	[1]: https://bugzilla.kernel.org/show_bug.cgi?id=16506#c28
>>
>> If that is indeed so, we should abort the build? No?
> 
> Does it in fact still build with 3.4? I seem to recall some talk about
> pushing the minimum version to 4.x for x86, although I can't remember
> where..

It does indeed still build with 3.4, although it is giving us a bunch of
headaches to *make it so*, and I would personally be really glad if the
consensus is we can just axe it.

The only reason to not abort the build for gcc 3.3.3 is that soem
"enterprise" distros have been shipping gcc 3.3.3 with backported fixes
from 3.4, which of course still identifies themselves as gcc 3.3.3, and
so technically it is iompossioble to tell if any particular "gcc 3.3.3"
is actually broken or not.

However, as far as I can tell, most of the people who build current x86
kernels with gcc 3.x are people who are testing building current kernels
with gcc 3.x.  Some of the embedded systems are different, because for
some strange reasons most of the embedded world seem stuck on gcc 3.4 or so.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

