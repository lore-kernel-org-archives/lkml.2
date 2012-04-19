Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab2DSXKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:10:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52438 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab2DSXKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:10:32 -0400
Message-ID: <4F909B56.60001@zytor.com>
Date: Thu, 19 Apr 2012 16:10:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tony Luck <tony.luck@gmail.com>, David Daney <ddaney.cavm@gmail.com>,
        Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
References: <1334794610-5546-1-git-send-email-hpa@zytor.com> <20120419092255.GA29542@aftab> <20120419092630.GD29542@aftab> <4F904541.2030200@zytor.com> <CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com> <20120419173802.GI3221@aftab.osrc.amd.com> <4F90527B.7020005@zytor.com> <CA+55aFxhY1Ug5esj==Sm=o1Epg+NFnvFs74syqRxbYDbPQJEFA@mail.gmail.com> <9ff2e09c-57e4-455e-8614-1b3b17b652f4@email.android.com> <4F9072CA.6030903@gmail.com> <4F908EA5.4060507@zytor.com> <CA+8MBbKz4GNs-mFj5=dCpRe_XLgoKZZz-8GM+FqTMTDBKqJNJw@mail.gmail.com> <CA+55aFx8EDb3MOrpky7aBf28=5XQ41ebuunO5aYrnUY1haVzcA@mail.gmail.com>
In-Reply-To: <CA+55aFx8EDb3MOrpky7aBf28=5XQ41ebuunO5aYrnUY1haVzcA@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 03:58 PM, Linus Torvalds wrote:
> 
> In fact, doing an "objdump" on the few modules I have, I didn't find a
> *single* exception table entry. Maybe I did something wrong? Isn't it
> the __ex_table in modules too?
> 

It is, but I suspect a lot of modules don't end up with any exception
table entries, as the common forms of user space access are out of line.

I suspect that just finding the module we're in or not in before
searching its ex_table is probably good enough, but a global hash would
be better.  That being said, some distros are complaining about the
amount of time it takes to load modules on boot...

	-hpa

