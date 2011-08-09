Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1HIQ6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:58:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51690 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab1HIQ6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:58:33 -0400
Message-ID: <4E416716.1040904@zytor.com>
Date: Tue, 09 Aug 2011 11:57:58 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com
Subject: Re: New vsyscall emulation breaks JITs
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com> <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com> <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org> <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com> <20110805212153.GL5782@one.firstfloor.org> <CAObL_7Exnu8rHNY67o_HutizpLrGMx0heYU8wKXeEutXZywvdA@mail.gmail.com> <20110809150424.GO5782@one.firstfloor.org> <CAObL_7HL7SwCfXsD3dPesE4cU-nmoMCRVCP6u2Mn8efo7EG5Zg@mail.gmail.com>
In-Reply-To: <CAObL_7HL7SwCfXsD3dPesE4cU-nmoMCRVCP6u2Mn8efo7EG5Zg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2011 10:22 AM, Andrew Lutomirski wrote:
> 
> In any case, my patch fixes DynamoRIO but not pin.  Pin dies with:
> 
> [ 4988.945491] test_vsyscall[4587] emulated vsyscall from bogus
> address -- fix your code nr: 0 ip:7fdc3a5ce78f cs:33 sp:7fffc2339a88
> ax:ffffffffff600000 si:0 di:400d0a
> [ 4988.945497] test_vsyscall[4587] vsyscall fault (exploit attempt?)
> nr: 0 ip:7fdc3a5ce78f cs:33 sp:7fffc2339a88 ax:ffffffffff600000 si:0
> di:400d0a
> 
> and I don't know what's going on.  I suspect that the tracer assumes
> that int 0x40 continues execution at the next instruction.
> 
> x86 maintainers: I can think of a few choices:
> 
> 1. Stick a ret instruction in the vsyscall page.  Downside: now
> there's an unrestricted ret instruction in the vsyscall page.
> 

How much worse is a ret instruction over the INT instructions that
modifies very little of the register state and then rets?

> 3. Apply my patch and assume that the number of users that would
> benefit from a more complete fix is close to zero, since pin won't
> even try to run on 3.0 or 3.1 without gross hacks.  (Pin is prerelease
> software and apparently actively maintained by people who make it very
> hard for non-users to contact, but I'm trying.)

Since pin is going to have to be fixed anyway to run on 3.x, it seems
reasonable to me that they can just fix their vsyscall handling at the
same time.

Now, the multimodal patch seems reasonable, too.

I think to some extent there are no actually good solutions here, just
varying degrees of bad.  Being able to completely disable vsyscall
without having to recompile seems attractive, though.

	-hpa

