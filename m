Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab1D0TiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:38:05 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34319 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab1D0TiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:38:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=t1Rb8/THU4Gd0ISLcjluJkf73EyaJyW181EX/ehG9SZyHV1wEQfzav1QF80Spg1BW7
         psUDYXkwwMk8bhMwIEopsuBwFpzf4ujKXRymErQXU2FbSX0EC7vbpnXgcOSgiNKoyjua
         /hfRLipVHj4V4S2BV7KbtqraMMns3rKhdu2xQ=
MIME-Version: 1.0
In-Reply-To: <1303931761.18763.101.camel@gandalf.stny.rr.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	<e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>
	<1303926576.18763.75.camel@gandalf.stny.rr.com>
	<4DB86163.2070201@zytor.com>
	<BANLkTikQiA9iwSs1qX7-76GKUN23GV=8Uw@mail.gmail.com>
	<1303931761.18763.101.camel@gandalf.stny.rr.com>
Date: Wed, 27 Apr 2011 22:38:01 +0300
X-Google-Sender-Auth: g_Y4qaWa8e4xpEsOQTqioncltnM
Message-ID: <BANLkTi=xRJ+rRRpYWuLxtRiLfYZwsBU0vQ@mail.gmail.com>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Pekka Enberg <penberg@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thiago Farina <tfransosi@gmail.com>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, "Ted Ts'o" <tytso@mit.edu>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:16 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-04-27 at 21:51 +0300, Pekka Enberg wrote:
>
>> It's the same kind of API extension kstrdup(), for example, is.
>> Whether or not we should it do it is a separate matter and I think the
>> only reasonable argument for and against is whether it (a) reduces the
>> number of bugs,
>
> I did a quick search through the git logs, and found no bug fixes due to
> the semantics. At least by the time it got to mainline, they are fixed
> (which is a good thing).
>
>
>>  (b) improves code readability significantly,
>
> This is a matter of preference. I think I would prefer it, but obviously
> others do not.
>
>
>>  or (c)
>> generates better code.
>
> If we implement streq() separately from strcmp() it gets slightly
> better:

We'd probably end up with both in the tree, though, which is not an
improvement. With kstrdup(), for example, we were able to move code
out-of-line which improved the whole kernel.

To be honest, I don't think the arguments for streq() are that strong
but I wanted to point out that the arguments against it weren't all
that great either...

                        Pekka
