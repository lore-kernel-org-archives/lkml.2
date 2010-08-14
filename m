Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934744Ab0HNR1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 13:27:46 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39988 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627Ab0HNR1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 13:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Z7XUchs3kfBbr0fufwVQwz+GRwcYGpVdQVTWL+EGiCqn1J1v/abT7/dh64PTJzZKQB
         J2SNyagbqlEkGjOLyqFHpu91vlkEKoTqhiowsJ1pSASRyAXRXqY4EyXfMRv/JTjj1EZ7
         Zj6GisABCSXzwrei34CMAg0v4AxKIT5mtOaLs=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTik0gSCA4YAH5VAfmW+a4d5R_nybgLiXa_koWn48@mail.gmail.com>
References: <AANLkTimNborh0AtHkdnN-aCizDu4+S6ORmeoKzS_nEVH@mail.gmail.com>
	<AANLkTik0gSCA4YAH5VAfmW+a4d5R_nybgLiXa_koWn48@mail.gmail.com>
Date: Sat, 14 Aug 2010 19:27:44 +0200
Message-ID: <AANLkTikNTZSqZ-sa0uGY0FnjDnOziu4qR8fEitD2TPQc@mail.gmail.com>
Subject: Re: Linux 2.6.35.2
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        penberg@kernel.org, arthur@psw.ro, wylda@volny.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CC-ing wylda@volny.cz ]

On Sat, Aug 14, 2010 at 7:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Aug 14, 2010 at 5:37 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>
>> root@tbox:~# grep "Aug 14 13:00:5" /var/log/syslog
>> Aug 14 13:00:53 tbox kernel: [ 1084.804086] BUG: scheduling while atomic: bash/3256/0x10000001
>
> Gaah. Locking problem. We really should have let this one simmer in
> -devel a bit longer before rushing it into -stable.
>
> Attached potential patch. Untested, but I forgot about the locking in
> the first version of the patch, and then the "trivial one-liner fix"
> missed the deeper problem.
>
> Greg - please don't use this patch yet. I'll test it. And wait for
> verification that it fixes other peoblems too.
>
>                    Linus
>

Just, doing a 2.6.35-git15 kernel build on a system w/ 2.6.35.2 kernel
and revert-patches applied.
5 parallel-make-jobs, open Firefox and quassel IRC client - Pentium-M
1.7G, 1G RAM, 60G HDD.

Looks fine so far (approx. 1.5hrs build-time).

Only to clarify, your new single patch replaces...???

mm: fix missing page table unmap for stack guard page failure case
mm: keep a guard page below a grow-down stack segment

Will report later if new upstream (aka 2.6.36) with revert-patches
works fine, too.

- Sedat -
