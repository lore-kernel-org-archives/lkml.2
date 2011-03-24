Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab1CXSbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:31:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52930 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458Ab1CXSa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HZ6jvtzQiSESdkZ12yoB/doZRmXw5eEbdCPSuRVcdkJ1Em1vbl2CXMKBikPY2A6oZo
         35QxzXyx9n834gL2cSExsyupm2Y3lQQMaaqoN+XmXAmt7bZgJoUlT+WThIY7ijQ6guQi
         eNNTkvU5+Uxa1LqGpaeQvtndfQ89GSnOGEUpc=
MIME-Version: 1.0
In-Reply-To: <AANLkTinnTnPrS=rPssO6HiV_7tkGchDpxq6SJprL70ub@mail.gmail.com>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
	<20110317211548.646b04d2@tpl.lwn.net>
	<1300419170.16880.956.camel@gandalf.stny.rr.com>
	<AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
	<AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
	<Pine.LNX.4.64.1103200852080.28495@ask.diku.dk>
	<AANLkTi=MMKvA-9pFiM1K_JSXjS71JLRCem8THnhu-0=N@mail.gmail.com>
	<Pine.LNX.4.64.1103201007430.28495@ask.diku.dk>
	<8762r8mt0h.fsf@linux.vnet.ibm.com>
	<Pine.LNX.4.64.1103241705510.8624@pc-004.diku.dk>
	<AANLkTinnTnPrS=rPssO6HiV_7tkGchDpxq6SJprL70ub@mail.gmail.com>
Date: Thu, 24 Mar 2011 14:30:58 -0400
Message-ID: <AANLkTikL=PpJFvx4sC9c22Yf8QUivy2ZwwPhd_iNX+W=@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
From: Arnaud Lacombe <lacombar@gmail.com>
To: Nicolas Palix <Nicolas.Palix@inria.fr>
Cc: Julia Lawall <julia@diku.dk>,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/3/24 Nicolas Palix <Nicolas.Palix@inria.fr>:
> On Thu, Mar 24, 2011 at 5:08 PM, Julia Lawall <julia@diku.dk> wrote:
>> On Thu, 24 Mar 2011, Aneesh Kumar K. V wrote:
>>
>>> On Sun, 20 Mar 2011 10:17:07 +0100 (CET), Julia Lawall <julia@diku.dk> wrote:
>>> > On Sun, 20 Mar 2011, Pekka Enberg wrote:
>>> >
>>> > > Hi Julia,
>>> > >
>>> > > On Sun, Mar 20, 2011 at 10:01 AM, Julia Lawall <julia@diku.dk> wrote:
>>> > > > Suggestions for how to make it easier to use or the documentation more
>>> > > > understandable are welcome.
>>> > >
>>> > > The benefit of scripts/checkpatch.pl is that it doesn't require any
>>> > > setting up to do. I'm personally less likely to use Coccinelle (and
>>> > > Sparse for that matter) on boxes where the software is not installed.
>>> > > I'm not sure how other people feel about it, but I'd personally love
>>> > > to see tools/coccinelle and tools/sparse.
>>> >
>>> > This was discussed before, and it was felt that perhaps 75000 lines of
>>> > ocaml code was not really appropriate for the Linux source tree, and also
>>> > that it would too much complicate our development process.
>>> >
>>> > One reason for using multiple machines would be to work on multiple
>>> > architectures.  But Coccinelle is not sensitive to the architecture on
>>> > which it is run, so perhaps you do't need to have it installed everywhere.
>>> >
>>> > > As for something more concrete, I guess this is what I'm mostly interested in:
>>> > >
>>> > > penberg@jaguar:~/src/linux$ make C=1 CHECK="scripts/coccicheck" mm/slub.o
>>> > >
>>> > > I guess it'd be good to document that for 'make help' because now you
>>> > > need to dig through Documentation/coccinelle.txt to find it.
>>> >
>>> > OK, thanks.  We will look into that.
>>> >
>>> > > P.S. It seems there's a bug somewhere because the above command fails
>>> > > miserably for me:
>>> > >
>>> > >   CHK     include/linux/version.h
>>> > >   CHK     include/generated/utsrelease.h
>>> > >   CALL    scripts/checksyscalls.sh
>>> > >   CHECK   mm/slub.c
>>> > > File "/home/penberg/src/linux/scripts/coccinelle/api/memdup_user.cocci",
>>> > > line 32, column 5,  charpos = 747
>>> > >     around = '<+...', whole content = -    <+... when != goto l2;
>>> > > Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty
>>> > > context: <+...")
>>> > > File "/home/penberg/src/linux/scripts/coccinelle/api/memdup_user.cocci",
>>> > > line 32, column 5,  charpos = 747
>>> > >     around = '<+...', whole content = -    <+... when != goto l2;
>>> > > Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty
>>> > > context: <+...")
>>> > > File "/home/penberg/src/linux/scripts/coccinelle/api/memdup_user.cocci",
>>> > > line 32, column 5,  charpos = 747
>>> > >     around = '<+...', whole content = -    <+... when != goto l2;
>>> > > Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty
>>> > > context: <+...")
>>> > > File "/home/penberg/src/linux/scripts/coccinelle/api/memdup_user.cocci",
>>> > > line 32, column 5,  charpos = 747
>>> > >     around = '<+...', whole content = -    <+... when != goto l2;
>>> > > Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty
>>> > > context: <+...")
>>> > > make[1]: *** [mm/slub.o] Error 1
>>> > > make: *** [mm/slub.o] Error 2
>>> > >
>>> > > penberg@jaguar:~/src/linux$ dpkg -l|grep coccinelle
>>> > > ii  coccinelle                                      0.2.2.deb-2
>>> > >                                         semantic patching tool for C
>>> > >
>>> > > [ I'm on Ubuntu 10.10. ]
>>> >
>>> > Indeed that one seems to be quite out of date.  You can get the most
>>> > recent version here: https://launchpad.net/~npalix/+archive/coccinelle
>>>
>>> I never got a working version of coccinelle with scripts in the kernel.
>>> Even the ppa version doesn't work for me.
>>>
>>> make  C=2  CHECK=scripts/coccicheck fs/namei.o
>>> ...
>>> ....
>>>   CHECK   scripts/mod/empty.c
>>> File "/home/opensource/sources/kernels/linux-2.6/scripts/coccinelle/api/memdup_user.cocci", line 32, column 5,  charpos = 747
>>>     around = '<+...', whole content = -    <+... when != goto l2;
>>> Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty context: <+...")
>>> File "/home/opensource/sources/kernels/linux-2.6/scripts/coccinelle/api/memdup_user.cocci", line 32, column 5,  charpos = 747
>>>     around = '<+...', whole content = -    <+... when != goto l2;
>>> Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty context: <+...")
>>> File "/home/opensource/sources/kernels/linux-2.6/scripts/coccinelle/api/memdup_user.cocci", line 32, column 5,  charpos = 747
>>>     around = '<+...', whole content = -    <+... when != goto l2;
>>> Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty context: <+...")
>>> File "/home/opensource/sources/kernels/linux-2.6/scripts/coccinelle/api/memdup_user.cocci", line 32, column 5,  charpos = 747
>>>     around = '<+...', whole content = -    <+... when != goto l2;
>>> Fatal error: exception Lexer_cocci.Lexical("invalid in a nonempty context: <+...")
>>
>> That's quite strange.  Could you check that you are using the ppa version
>> and not the old version?  spatch -version should give you 0.2.5-rc8
>
> Indeed... I just checked and I got not error.
>
> npalix@penpen:~/Build/linux$ make  C=2  CHECK=scripts/coccicheck
> COCCI="scripts/coccinelle/api/memdup_user.cocci" fs/namei.o
>  CHK     include/linux/version.h
>  CHK     include/generated/utsrelease.h
>  CALL    scripts/checksyscalls.sh
>  CHECK   scripts/mod/empty.c
>  CHECK   fs/namei.c
> npalix@penpen:~/Build/linux$ make  C=2  CHECK=scripts/coccicheck
> fs/namei.o  CHK     include/linux/version.h
>  CHK     include/generated/utsrelease.h
>  CALL    scripts/checksyscalls.sh
>  CHECK   scripts/mod/empty.c
>  CHECK   fs/namei.c
> npalix@penpen:~/Build/linux$ spatch -version
> spatch version 0.2.5-rc8 with Python support
>
So does it mean that you do not even have a stable grammar ? Do you at
least offer any guarantee that a script made for version X will still
work in version X+1 ?

Thanks,
 - Arnaud
