Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1AOIKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 03:10:40 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50140 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1AOIKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 03:10:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=h1FDVeJuVu2H9xbg9jNMbOi+pB5QETmUIL9VaXbzoodz2P56A3mbor8hOjhfEk/YHp
         7/t8kPBx7aX+cboF55PE/f4CxwDKqttUVTyfSyISZclBY+8fELR1fIJaJ99ZsM8hVUaO
         Pw2Yzk7yD7WGtb7AwWWwhJZcHNx8KhznkRAwg=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110115075723.GJ19804@ZenIV.linux.org.uk>
References: <AANLkTik4JfjBEurjX4T3sAtGf9CPJvQYkV5aZWgE=XD1@mail.gmail.com>
	<AANLkTin0SUG3Q3aHVfBqCV8=iWThy3MTfG90ikMsrox9@mail.gmail.com>
	<20110115075723.GJ19804@ZenIV.linux.org.uk>
Date: Sat, 15 Jan 2011 09:10:36 +0100
Message-ID: <AANLkTinNVp1r2+w7Uxh4AG=_8bTaOTm_oxfg8zc8O1CY@mail.gmail.com>
Subject: Re: linux-next: Tree for January 15 (Call Trace in fs/dcache.c + autofs4)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, raven@themaw.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 8:57 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Jan 15, 2011 at 08:46:20AM +0100, Sedat Dilek wrote:
>
>> Will try the patch from [1] as there was no feedback yet.
>>
>> - Sedat -
>>
>> [1] https://lkml.org/lkml/2011/1/12/394
>
> There's also vfsmount refcounting breakage somewhere in automount series,
> unfortunately caught only when redoing said refcounting on top of it [1] ;-/
> I'm bisecting it right now, will post when it's done.
>
> [1] with mnt{get,put}_long() variant the breakage is present, but not
> immediately noticable.  With (local) rewrite to saner rules it became
> visible, but I spent quite a while trying to find the bug in the most
> obvious place - i.e. that rewrite.
>

[ CCing Ian Kent ]

The winner is... Have a nice breakfast :-)

The patch (which is once again hided in a thread posting) from [1]
does not cleanly apply against linux-next (next-20110115).
But if you say there is more to be done I can be patient and won't try
to adapt the patch by Ian Kent.

- Sedat -

[1] https://patchwork.kernel.org/patch/475201/

P.S.:

sd@tbox:~/src/linux-2.6/linux-2.6.37/debian/build/source_i386_none$
LC_ALL=C quilt -f push
Applying patch autofs4-fix/autofs4-set-dentry-op-in-lookup-only.patch
patching file fs/autofs4/root.c
Hunk #1 FAILED at 419.
Hunk #2 FAILED at 568.
Hunk #3 succeeded at 521 (offset -68 lines).
Hunk #4 FAILED at 716.
Hunk #5 succeeded at 586 (offset -148 lines).
Hunk #6 FAILED at 853.
Hunk #7 succeeded at 774 (offset -96 lines).
Hunk #8 FAILED at 950.
5 out of 8 hunks FAILED -- saving rejects to file fs/autofs4/root.c.rej
Applied patch autofs4-fix/autofs4-set-dentry-op-in-lookup-only.patch
(forced; needs refresh)
