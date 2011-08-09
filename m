Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1HIWg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 18:36:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314Ab1HIWg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 18:36:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7G09yBtfFpdvmRMNn59T-jTsj_MFK+xBer+qq3BUjcKUg@mail.gmail.com>
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com>
 <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com>
 <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org>
 <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com>
 <20110805212153.GL5782@one.firstfloor.org> <CAObL_7Exnu8rHNY67o_HutizpLrGMx0heYU8wKXeEutXZywvdA@mail.gmail.com>
 <20110809150424.GO5782@one.firstfloor.org> <CAObL_7HL7SwCfXsD3dPesE4cU-nmoMCRVCP6u2Mn8efo7EG5Zg@mail.gmail.com>
 <4E416716.1040904@zytor.com> <CAObL_7FzTisOGJLP7wGUKDCO6qJ20-kaMFWdjm0a+dKpNWBe3g@mail.gmail.com>
 <1312919938.17118.YahooMailNeo@web120010.mail.ne1.yahoo.com> <CAObL_7G09yBtfFpdvmRMNn59T-jTsj_MFK+xBer+qq3BUjcKUg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Aug 2011 15:36:06 -0700
Message-ID: <CA+55aFyV65BNjdsmS9oTaRwWzyJZS3BDEDJBx5Poy-vGp5iN_Q@mail.gmail.com>
Subject: Re: New vsyscall emulation breaks JITs
To: Andrew Lutomirski <luto@mit.edu>
Cc: Greg Lueck <lueckintel@yahoo.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kimwooyoung@gmail.com" <kimwooyoung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 2:04 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> Here's a different proposal, then:
>
> What if the kernel had the sequence:
>
> mov $__NR_whatever,%eax
> syscall
> ret
>
> in the vsyscall page but marked the vsyscall page NX.

This sounds like a sound idea. And then the difference between "fast
and native" and "slow and trapping" ends up literally being just the
NX bit.

                        Linus
