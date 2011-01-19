Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab1ASODZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 09:03:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52342 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab1ASODY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 09:03:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YyMcQ8ig1OL28wdowICcaAqmLXlu76cmbX6X5ShsCtC3fnaVwkPZxz92/smY2QNT0d
         Fl4atyUapfInKGRXq03T+zm0n5xc0LwnzSy/Rjj/YVi/3b06ZH4yP9aWAksTa9eqgGuN
         6Q2y9Ah+icKOt61ww96TPUTRHZ9iWv0QMRROU=
MIME-Version: 1.0
In-Reply-To: <AANLkTimdtFtextcHTwUA93AL7EQegeC26M7mWLsQKdZU@mail.gmail.com>
References: <AANLkTikCw74WyhmLAjnBn_vd=iPWe-QEZCP-N+ghSRoC@mail.gmail.com>
	<AANLkTimdtFtextcHTwUA93AL7EQegeC26M7mWLsQKdZU@mail.gmail.com>
Date: Wed, 19 Jan 2011 22:03:22 +0800
Message-ID: <AANLkTinZtu11Gi1xj76_Oaqg0V-V-3zQ7h_7L5=7rNHN@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc1 doesn't boot
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: sedat.dilek@gmail.com, Markus Trippelsdorf <markus@trippelsdorf.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Matthias Klose <doko@debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 8:31 PM, H.J. Lu <hjl.tools@gmail.com> wrote:
> On Wed, Jan 19, 2011 at 12:32 AM, Sedat Dilek
> <sedat.dilek@googlemail.com> wrote:
>> Referring to the original posting from [1]:
>>
>> I am on latest linux-next (next-20110118) which has also [3] included,
>> x86_32 and using binutils-2.21 with PR ld/12327 fix from
>> Debian/experimental (see [2]).
>>
>> AFAICS the changes to my kernel-config... You are on x86_64 and have not set:
>>
>> CONFIG_RELOCATABLE=y
>> CONFIG_X86_NEED_RELOCS=y
>>
>> Ifdef *also* for CONFIG_RELOCATABLE for the parts in commit from [3] ?
>>
>> - Sedat -
>>
>> [1] http://lkml.org/lkml/2011/1/19/52
>> [2] http://bazaar.launchpad.net/~doko/binutils/pkg-2.21-debian/revision/85
>> [3] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=86b1e8dd83cbb0
>>
>
> Looks like the patch has been reverted.

Can't boot here too. I don't have CONFIG_RELOCATABLE set on 64-bit.


Reverting the commit  solves the problem.

commit 86b1e8dd83cbb0fcbf3d61d2b461df8be1f528cf
Author: Shaohua Li <shaohua.li@intel.com>
Date:   Tue Jan 18 08:57:49 2011 +0800

    x86: Make relocatable kernel work with new binutils

    The CONFIG_RELOCATABLE=y option is broken with new binutils, which will make
    boot panic.

    According to Lu Hongjiu, the affected binutils are from 2.20.51.0.12 to
    2.21.51.0.3, which are release since Oct 22 this year. At least
ubuntu 10.10 is


Thanks,
Jeff.
