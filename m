Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1HIW1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 18:27:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:50048 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab1HIW1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 18:27:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,345,1309762800"; 
   d="scan'208";a="5600653"
Subject: Re: New vsyscall emulation breaks JITs
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Lutomirski <luto@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "lueckintel@yahoo.com" <lueckintel@yahoo.com>,
        "kimwooyoung@gmail.com" <kimwooyoung@gmail.com>
In-Reply-To: <4E3C8B8A.3080007@zytor.com>
References: <20110805200945.GA14014@tassilo.jf.intel.com>
	 <4E3C5154.2050307@zytor.com>
	 <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com>
	 <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org>
	 <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com>
	 <20110805212153.GL5782@one.firstfloor.org>
	 <CAObL_7GuauANLqM9DnbYnhRuOsnqE+fTEoM10qCfjc40eFHaUA@mail.gmail.com>
	 <4E3C6982.5050901@zytor.com>
	 <CAObL_7GB_wpNhn=oKcmutWuB+RiQ9QXwtZ7v-duOy3wjyCLpNg@mail.gmail.com>
	 <CAObL_7HPgqvoBm4pkTi9ZmF1K0SsyQWKev_idzjLJ9ST=RO=9A@mail.gmail.com>
	 <4E3C8B8A.3080007@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 09 Aug 2011 15:27:24 -0700
Message-Id: <1312928844.25213.25.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 17:32 -0700, H. Peter Anvin wrote:
> On 08/05/2011 05:20 PM, Andrew Lutomirski wrote:
> > 
> > I was thinking of 0x20 - 0x39.  0x40, 0x41, and 0x42 should do the
> > trick.  I'll cook up a patch.
> > 
> > If you want to keep those vectors available for devices as well, we
> > could hook do_general_protection instead, but that's a little messy.
> > Are there x86 machines out there that are starved for interrupt
> > vectors?
> > 
> 
> Yes, but 3 aren't going to matter much.
> 
> However, on systems which have interrupt migration enabled we're not
> using 0x21-0x2f for anything (because we need a single interrupt with
> absolutely lowest priority).

Double checked to make sure and we actually allow 0x21-0x2f to be used
for device interrupts (commit 6579b474572fd54c583ac074e8e7aaae926c62ef).
So reserving the vectors in this range should be same as reserving in
any other range available for use.

Thanks.

>   Out of that range, there are a couple of
> values which should be safe to use because they would be harmless
> instructions of various forms:
> 
> 	0x24	- AND AL, imm8
> 	0x25	- AND EAX, imm32
> 	0x26	- ES:
> 	0x2C	- SUB AL, imm8
> 	0x2D	- SUB EAX, imm32
> 	0x2E	- CS:
> 
> [Cc: Suresh who is the expert on the interrupt assignments]
> 
> 	-hpa

