Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab1ELOa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:30:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55916 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1ELOa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=pcJlf4oxOWuXj1xn/XFgHvfwxoBDIio0v6Dw0CDSNryF0L3R+KngtGYkLqtkJ7PqSY
         GpxQcqfHh7Eu8x8DhMMoS9IVEvCAUegZ/xIMWG23UM0q1E6Tohyva7kCPPyJE7Lbb808
         1hY+Xg0+vnQJpYyalhV3G52uMxIZ4dS52f0m4=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=fhsSP069WMNPN8BA=E1=1TZ6Zmw@mail.gmail.com>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
 <BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com> <BANLkTimfFEv+vZ8dYvhG0oj2Q4g+KnG4aA@mail.gmail.com>
 <BANLkTinDiGCaKPtS+ZpKf2swJpParJ4eew@mail.gmail.com> <BANLkTi=JXq+V783amiJB-qLX=7PaeH-83w@mail.gmail.com>
 <BANLkTi=OXuR4iJFqUEa4pA=yO0aXaqEzyA@mail.gmail.com> <BANLkTikFSN-DkkPNPtv1VigCg08YoB_q2g@mail.gmail.com>
 <BANLkTi=fhsSP069WMNPN8BA=E1=1TZ6Zmw@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 12 May 2011 10:30:34 -0400
Message-ID: <BANLkTikyR7ByAgxtbz-gOHspLMFo4a+vaQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Speed up the symbols' resolution process V4
To: Alessio Igor Bogani <abogani@kernel.org>
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

On Thu, May 12, 2011 at 05:10, Alessio Igor Bogani wrote:
> 2011/5/11 Mike Frysinger:
> [...]
>> if you export _foo/foo, you'll get an error with the current code:
>> /* EXPORT_SYMBOL(foo); */
>>        .section        ___ksymtab__foo,"a",@progbits
>> ___ksymtab_foo:
>> /* EXPORT_SYMBOL(_foo); */
>>        .section        ___ksymtab___foo,"a",@progbits
>> ___ksymtab__foo:
> [...]
>
> So I can suggest two possible solutions for section names:
>
> 1) As you suggested change "__" to "+" so
> i.e. ___ksymtab+foo
>
> 2) Pick a more appropriate name:
> i.e. ___ksym__foo
> or
> i.e. ___ksymsec__foo
>
> In fact these section names aren't a table of symbols (in ksymtab the
> "tab" part stand for table, I suppose) so I think that name should be
> changed accordingly (my patchset create a temporary section for every
> symbol).
>
> Which do you prefer?

i suggested the diff split char as i dont know how embedded the
"ksymtab" section name is in the rest of the tree.  but if changing
that is an option, that'd work too.  either works for me, so whichever
is less effort for you.
-mike
