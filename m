Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1ELJK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:10:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49507 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab1ELJKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oycm5KIGH2gO7lrMS0NLvZP7qG8YzL8+5nWEuOR7QPLX1yPIJyqQWFbGIFNxsRYp/D
         Y+Fn8FrHw4UHDXgZ2960ykhCqLLZglHnx9qbU3Yjuj8rzUhNbkkvCSBny/vAtvQKCmYY
         2N0dJVqVBrjUZyUPvmoQAbrhUCC28NoAPro5s=
MIME-Version: 1.0
In-Reply-To: <BANLkTikFSN-DkkPNPtv1VigCg08YoB_q2g@mail.gmail.com>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
	<BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com>
	<BANLkTimfFEv+vZ8dYvhG0oj2Q4g+KnG4aA@mail.gmail.com>
	<BANLkTinDiGCaKPtS+ZpKf2swJpParJ4eew@mail.gmail.com>
	<BANLkTi=JXq+V783amiJB-qLX=7PaeH-83w@mail.gmail.com>
	<BANLkTi=OXuR4iJFqUEa4pA=yO0aXaqEzyA@mail.gmail.com>
	<BANLkTikFSN-DkkPNPtv1VigCg08YoB_q2g@mail.gmail.com>
Date: Thu, 12 May 2011 11:10:24 +0200
X-Google-Sender-Auth: GHxI7IM11GsE-r8t4DkXkyam7Rg
Message-ID: <BANLkTi=fhsSP069WMNPN8BA=E1=1TZ6Zmw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Speed up the symbols' resolution process V4
From: Alessio Igor Bogani <abogani@kernel.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Frysinger,

Thank you for excellent explanation!

2011/5/11 Mike Frysinger <vapier.adi@gmail.com>:
[...]
> if you export _foo/foo, you'll get an error with the current code:
> /* EXPORT_SYMBOL(foo); */
>        .section        ___ksymtab__foo,"a",@progbits
> ___ksymtab_foo:
> /* EXPORT_SYMBOL(_foo); */
>        .section        ___ksymtab___foo,"a",@progbits
> ___ksymtab__foo:
[...]

So I can suggest two possible solutions for section names:

1) As you suggested change "__" to "+" so
i.e. ___ksymtab+foo

2) Pick a more appropriate name:
i.e. ___ksym__foo
or
i.e. ___ksymsec__foo

In fact these section names aren't a table of symbols (in ksymtab the
"tab" part stand for table, I suppose) so I think that name should be
changed accordingly (my patchset create a temporary section for every
symbol).

Which do you prefer?

Ciao,
Alessio
