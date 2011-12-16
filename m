Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786Ab1LPQ14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:27:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab1LPQ1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:27:50 -0500
Message-ID: <4EEB715D.30301@redhat.com>
Date: Fri, 16 Dec 2011 08:27:09 -0800
From: Richard Henderson <rth@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] x86: Use -m-omit-leaf-frame-pointer to shrink text size
References: <20111216081915.GA28288@elte.hu> <20111216085259.GA2338@elte.hu>  <4EEB0E14.9050505@goop.org> <1324030817.18942.76.camel@twins>
In-Reply-To: <1324030817.18942.76.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 02:20 AM, Peter Zijlstra wrote:
>> How can we tell gcc the asm contains a call, or otherwise suppress the
>> "leaf function" classification?

You can't at present.

> I only found the function __attribute__((leaf)) to explicitly mark a
> function as being a leaf function, but the documentation doesn't list
> the inverse of that to explicitly mark it as _not_ being one.

In any case, "leaf" doesn't do what you think it does -- see the docs.
I told Honza at the time that he was overloading existing terminology
without  purpose, but no one came up with a better name before the
release, so it stayed that way.  AFAIK, no one uses it because no one
understands it.

Do you have a proposal for what you'd like the extension to look like?
The only thing that comes to mind atm is "call" in the clobber section.
This is not likely to get written before gcc 4.8 though...


r~
