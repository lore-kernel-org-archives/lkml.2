Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab1HXXar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:30:47 -0400
Received: from claw.goop.org ([74.207.240.146]:54000 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab1HXXaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:30:46 -0400
Message-ID: <4E5589A4.8000606@goop.org>
Date: Wed, 24 Aug 2011 16:30:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 00/18] x86: Ticket lock + cmpxchg cleanup
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <1314209019.6925.53.camel@twins> <CA+55aFwuz14ez9=2wiG-344ua0tAJNL8ZuCC41fm6aFgCp+Txw@mail.gmail.com> <4E555AD0.3020101@goop.org> <CA+55aFwp6EM1rwP9k8RCj_M5bzPCkR1N1d9a-VZmYaZNyCNC=A@mail.gmail.com> <4E558236.9000707@goop.org> <4E5583B3.8080309@zytor.com> <CA+55aFw5T_rkH7195E=P_YO9sjvJbsG4j6n40=fXbdrJktAYjQ@mail.gmail.com> <CA+55aFy2E+t2oNGPe1nx4nRXMiFaq29h6F1x8H+sVDoHDiryZQ@mail.gmail.com>
In-Reply-To: <CA+55aFy2E+t2oNGPe1nx4nRXMiFaq29h6F1x8H+sVDoHDiryZQ@mail.gmail.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 04:21 PM, Linus Torvalds wrote:
> On Wed, Aug 24, 2011 at 4:09 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> However, the reason I disagree with it is that I don't think that it's
>> any prettier at all to have the two barriers than it is to just have
>> the asm.
> .. and btw, we probably do need *both* barriers. We definitely need
> the one before. The one after is a bit less obvious, since it is
> technically legal for code to move into the locked region. However,
> it's not necessarily a *good* idea for code to move into the locked
> region, so the two barriers are likely the RightThing(tm).

Originally I left the second barrier off for that reason, but I got
mysterious lockups.  The second barrier fixed them, so I never got
around to do a full root-cause analysis.

I still think the C version is more straightforward given that the asm
version is confused with the details of the ticket sizes, etc.  But,
shrug, its a pretty minor detail.

The OOSTORE stuff is a complete red herring; I bet its been *years*
since someone specifically compiled a kernel with OOSTORE SMP support
because they actually wanted to use it.

    J
