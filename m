Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab2BASqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 13:46:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab2BASqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 13:46:49 -0500
Message-ID: <4F298865.5000409@redhat.com>
Date: Wed, 01 Feb 2012 11:45:57 -0700
From: Jeff Law <law@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: matz@suse.de, jkosina@suse.cz, torvalds@linux-foundation.org,
        walters@verbum.org, jack@suse.cz, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, dsterba@suse.cz, ptesarik@suse.cz,
        rguenther@suse.de, gcc@gcc.gnu.org
Subject: Re: Memory corruption due to word sharing
References: <CA+55aFxmdskUXX1iBaPx7rUGD95UqNJxhe1BLeVtZjqHjBpsPA@mail.gmail.com>	<alpine.LRH.2.00.1202011808240.22725@twin.jikos.cz>	<Pine.LNX.4.64.1202011818570.25409@wotan.suse.de> <20120201.130905.1131458895704793597.davem@davemloft.net>
In-Reply-To: <20120201.130905.1131458895704793597.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2012 11:09 AM, David Miller wrote:
> From: Michael Matz<matz@suse.de>
> Date: Wed, 1 Feb 2012 18:41:05 +0100 (CET)
>
>> One problem is that it's not a new problem, GCC emitted similar code since
>> about forever, and still they turned up only now (well, probably because
>> ia64 is dead, but sparc64 should have similar problems).
>
> Indeed, on sparc64 it does do the silly 64-bit access too:
>
> wrong:
>          ldx     [%o0+8], %g2
>          sethi   %hi(2147483648), %g1
>          or      %g2, %g1, %g1
>          jmp     %o7+8
>           stx    %g1, [%o0+8]
>
> Personally I've avoided C bitfields like the plague in any code I've
> written.
Torvald Riegel & I were told that was kernel policy when we brought up 
the upcoming bitfield semantic changes with some of the linux kernel 
folks last year.

Regardless of the kernel team's policy WRT bitfields, I believe fixing 
the semantics to avoid creation of data races in bitfields is going to 
be important.  I'm hoping Aldy can return to that task soon and he and 
Richi can come to some agreement on the implementation with gcc-4.8 as a 
target.

jeff
