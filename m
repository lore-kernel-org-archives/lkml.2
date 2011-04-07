Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab1DGMJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:09:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60279 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab1DGMJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ivWjiqLnCYyJOye+MuPJ1ySFpWA9B6mYN5IPHNbBFp8cew9KDD+h7fzR66jINuY/Di
         UVhpzIhS5/u8Mh9hJTKaPdjl3TC0dpsD5vEkohFzMiS+sQtfDKj//i7SCVpy0nN6uBtd
         sHyFUW3qVWSEzo8pCuIXa++SQQShrw7OQhV44=
MIME-Version: 1.0
In-Reply-To: <20110329101630.1f1f0364@lxorguk.ukuu.org.uk>
References: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
	<AANLkTi=W0mW2o2muNgMnb1OQ6WaBeOmu1VBHr8Zf63r9@mail.gmail.com>
	<20110326120847.71b6ae4d@lxorguk.ukuu.org.uk>
	<20110328180655.GI2287@linux.vnet.ibm.com>
	<AANLkTin6kg84P50RHR7h6NG+P_nJK=N_Nefc1q4NxzY_@mail.gmail.com>
	<20110328231818.2297408f@lxorguk.ukuu.org.uk>
	<AANLkTimXztH_4f1=7-Ez6j-7UESroqwBvVuDNW7Fmewb@mail.gmail.com>
	<20110329101630.1f1f0364@lxorguk.ukuu.org.uk>
Date: Thu, 7 Apr 2011 13:09:29 +0100
Message-ID: <BANLkTinrEKyYhi3ZuQz4KeA+2m6pvU4ddg@mail.gmail.com>
Subject: Re: advice sought: practicality of SMP cache coherency implemented in
 assembler (and a hardware detect line)
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: paulmck@linux.vnet.ibm.com, Will Newton <will.newton@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alan, paul, will, apologies for not responding sooner, i've just moved
to near stranraer, in scotland.  och-aye.  the removal lorry has been
rescued from the mud by an 18 tonne tractor and we have not run over
any sheep.  yet.

On Tue, Mar 29, 2011 at 10:16 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>  hmmm, the question is, therefore: would the MOSIX DSM solution be
>> preferable, which i presume assumes that memory cannot be shared at
>> all, to a situation where you *could* at least get cache coherency in
>> userspace, if you're happy to tolerate a software interrupt handler
>> flushing the cache line manually?
>
> In theory DSM goes further than this. One way to think about DSM is cache
> coherency in software with a page size granularity. So you could imagine
> a hypothetical example where the physical MMU of each node and a memory
> manager layer comnunicating between them implemented a virtualised
> machine on top which was cache coherent.

> [...details of M.E.S.I ... ]

 well... the thing is that there already exists an MMU per core.
standard page-faults occur, etc. in this instance (i think!), just as
would occur in any much more standard SIMD architecture (with normal
hardware-based 1st level cache coherency)

 hm - does this statement sound reasonable:  this is sort-of a
second-tier of MMU principles, with a page size granularity of 8 bytes
(!) with oo 4096 or 8192 such "pages" (32 or 64k or whatever of 1st
level cache).  thus, the principles you're describing [M.E.S.I] could
be applied, even at that rather small level of granularity.

 or... wait... "invalid" is taken care of at a hardware level, isn't
it? [this is 1st level cache]

 much appreciated the thoughts and discussion so far.

 l.
