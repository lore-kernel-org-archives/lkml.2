Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab1HFAci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:32:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45913 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab1HFAcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:32:36 -0400
Message-ID: <4E3C8B8A.3080007@zytor.com>
Date: Fri, 05 Aug 2011 17:32:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: New vsyscall emulation breaks JITs
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com> <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com> <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org> <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com> <20110805212153.GL5782@one.firstfloor.org> <CAObL_7GuauANLqM9DnbYnhRuOsnqE+fTEoM10qCfjc40eFHaUA@mail.gmail.com> <4E3C6982.5050901@zytor.com> <CAObL_7GB_wpNhn=oKcmutWuB+RiQ9QXwtZ7v-duOy3wjyCLpNg@mail.gmail.com> <CAObL_7HPgqvoBm4pkTi9ZmF1K0SsyQWKev_idzjLJ9ST=RO=9A@mail.gmail.com>
In-Reply-To: <CAObL_7HPgqvoBm4pkTi9ZmF1K0SsyQWKev_idzjLJ9ST=RO=9A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 05:20 PM, Andrew Lutomirski wrote:
> 
> I was thinking of 0x20 - 0x39.  0x40, 0x41, and 0x42 should do the
> trick.  I'll cook up a patch.
> 
> If you want to keep those vectors available for devices as well, we
> could hook do_general_protection instead, but that's a little messy.
> Are there x86 machines out there that are starved for interrupt
> vectors?
> 

Yes, but 3 aren't going to matter much.

However, on systems which have interrupt migration enabled we're not
using 0x21-0x2f for anything (because we need a single interrupt with
absolutely lowest priority).  Out of that range, there are a couple of
values which should be safe to use because they would be harmless
instructions of various forms:

	0x24	- AND AL, imm8
	0x25	- AND EAX, imm32
	0x26	- ES:
	0x2C	- SUB AL, imm8
	0x2D	- SUB EAX, imm32
	0x2E	- CS:

[Cc: Suresh who is the expert on the interrupt assignments]

	-hpa
