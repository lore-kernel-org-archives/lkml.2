Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0IHRvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 13:51:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45712 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab0IHRvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 13:51:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Y2io6dZysKdL2025BbULfbZoQYMRE/EaEX+1hiH56eBYvn1CYRyAMoYM5UHXFRlI1N
         oRt73xO5eCA8Xz3u3cjMFWEnt105j1szwXcl8rUWjOOJg/l1POhPwq3E9OTWH4jniDiZ
         5QYjiM1x/KRwQtWBAfukgG6Wnjy48kwQWrUjE=
MIME-Version: 1.0
In-Reply-To: <20100908185605.55671889@lxorguk.ukuu.org.uk>
References: <fmbxh-5N8-41@gated-at.bofh.it>
	<55BC9463-95B9-4034-AA1E-55042D6E9354@gmail.com>
	<201009081115.15544.hpj@urpla.net>
	<AANLkTi=U40mzeMh-UJJy=ggVDry2qDWW-MYYyBhS_Kex@mail.gmail.com>
	<20100908185605.55671889@lxorguk.ukuu.org.uk>
Date: Wed, 8 Sep 2010 18:51:46 +0100
Message-ID: <AANLkTi=khD7fSVv_tC6TogimjJshEErj6Em8mCcDF+SM@mail.gmail.com>
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
From: Nick Lowe <nick.lowe@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It would only be through back-porting a form of this patch that it
would affect existing distributions, surely?

Why should it make it to the stable tree and a new kernel, though? The
chances are that if a distribution moves to a new kernel, they'll move
all the other packages up with it.

The Latest Ubuntu, for example, has been compiled against a version of
binutils that does not have this problem.

And nobody has answered what happens when NOPLs are used to
synchronise with something else? Surely that can lead to subtle, hard
to debug breakage? Isn't that plain worse than refusing to run or
breaking out of execution?

A CMOV was never used in that way so the fact it took longer to trap
and execute an emulation wouldn't have been a problem.

Cheers,

Nick

On Wed, Sep 8, 2010 at 6:56 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> If a process crashes because of NOPL usage, you get the feedback loop to fix it.
>
> Trouble is that means rebuilding entire distributios, who don't
> neccessarily care about Geode. We had the same problem before with cmov
> and the VIA processors, GCC programmers didn't read the Intel PPro
> manual and got it wrong but it was the end users who suffered, and most of
> them were not in a position to rebuild their distro (and every security
> update, and test them all ...) and their distro didn't care.
>
> So lots of people ran a kernel with a CMOV hack in it - never got
> mainstream which is unfortunate because if it had it would have helped
> a lot more people and had the hole in it fixed.
>
>> The beauty of open source is that we can recompile to correct the bad
>> assumption; the latest version of binutils (GAS) finally corrects the
>> bad semantic that generic i686 includes NOPL.
>
> And the reality is that this won't happen. Yes you can do it but it's an
> enormously slow and inefficient way to tackle the problem.
>
> So the patch (corrected) makes complete sense.
>
> Alan
>
