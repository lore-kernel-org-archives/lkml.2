Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0KMNfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 08:35:15 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46871 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab0KMNfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 08:35:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SDtkuwpJwhfsMov1Djx9ou8+cypWyazlYf29iPCWXZJg2FOlKCyRM9kUD8S+RaIhrk
         UDG0U8jpDufnQ9jyJdbwrHkaLme2Q9lbOeDxmXMGbHL+Pj7lNQC8FCCF9+LdrAKx2h6w
         S1lIOtWY9siffdN5k2yJyV5WI6aoRNm4+/nLM=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=dTW3WA-eLnnaHNcLdVKz7Bn41e8FE=67iVCyJ@mail.gmail.com>
References: <AANLkTikDXtLrfjYkQrkGi44qi0cpp-C+Lxr5j1UkFd2G@mail.gmail.com>
	<20101109224450.GB21992@kroah.com>
	<AANLkTimHOAdUieTzFvNNhaPxwvas2wBDfSL8aPu764HZ@mail.gmail.com>
	<20101110183940.GA15089@kroah.com>
	<AANLkTimTy0vngwuM=jWfeU7qgqznamPgAftX7=2LShL+@mail.gmail.com>
	<20101111121917.GA933@kroah.com>
	<AANLkTi=dTW3WA-eLnnaHNcLdVKz7Bn41e8FE=67iVCyJ@mail.gmail.com>
Date: Sat, 13 Nov 2010 19:35:10 +0600
Message-ID: <AANLkTin1wDCKc0A0PTtMPAALpLP0E3gL3J-AvFqEEqBG@mail.gmail.com>
Subject: Re: [PATCH] fs, sysfs: Change sysfs_pathname function prototype.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/10, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On 11/11/10, Greg KH <greg@kroah.com> wrote:
>>
>> perhaps, yes, that might be correct, but as almost no one builds with
>> WARN not enabled, is this a real issue?
>
> I'm trying to find out the config, which causes the warning (it gets
> overwritten). Not all config produces the warning. Maybe - it was a
> randconfig, which generates the warning. I'll again try some
> randconfig and will try to find the config which generates the
> warning. If I find something I'll notice. But, I think the issue is
> real.
>
CONFIG_EMBEDDED=y and CONFIG_BUG=n produces that warning, in that case
#ifndef WARN is defined as follows:

#define WARN(condition, format...) ({					\
	int __ret_warn_on = !!(condition);				\
	unlikely(__ret_warn_on);					\
})

from above we can see, format isn't used. sysfs_pathname is passed as
format when called from sysfs_add_one through WARN(). Since format
isn't used, that's why we're having that problem. Am I right? Should I
create a patch to split up WARN() and calling sysfs_pathname ? Or is
there any better way?


thanks,
rakib
