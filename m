Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0LOTPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:15:23 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:39001 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab0LOTPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:15:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fSrrwx2qAy68XpMPE7m2PB6QV9DU2flthH4zKsks3sw5tLQ058iODbraRYs+ZZdhM7
         ssL/FJPB3B3qdxGCHSbqo9WJobdSq62Z1CpXSdNFjaLL5XYtbHu0S1aMRtQCdyWx5Cja
         geNY0S2F+9OKIRgLSnHTir9Mm7++ycN3VwFLs=
MIME-Version: 1.0
In-Reply-To: <AANLkTinMWS-yyzWJ3oBo_KS9jXt4p4pveo+SPTLiWnCt@mail.gmail.com>
References: <20101210023852.GB3059@thunk.org>
	<AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
	<AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
	<AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
	<AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
	<20101212023415.GG3059@thunk.org>
	<AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
	<AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF@mail.gmail.com>
	<20101212124354.GA4513@thunk.org>
	<AANLkTikZkCs7Wee2=uhe3bw96Pggcv0jsCkZ+nkWEQ+=@mail.gmail.com>
	<20101213020657.GB4513@thunk.org>
	<AANLkTinMWS-yyzWJ3oBo_KS9jXt4p4pveo+SPTLiWnCt@mail.gmail.com>
Date: Wed, 15 Dec 2010 20:15:18 +0100
Message-ID: <AANLkTimjM_HptLaCSuQivxruWpoc7todyMe0wnszrSYU@mail.gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
From: Matt <jackdachef@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Jon Nelson <jnelson@jamponi.net>, Chris Mason <chris.mason@oracle.com>,
        Andi Kleen <andi@firstfloor.org>, Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <mbroz@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 7:56 PM, Jon Nelson <jnelson@jamponi.net> wrote:
> On Sun, Dec 12, 2010 at 8:06 PM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Sun, Dec 12, 2010 at 07:11:28AM -0600, Jon Nelson wrote:
>>> I'm glad you've been able to reproduce the problem! If you should need
>>> any further assistance, please do not hesitate to ask.
>>
>> This patch seems to fix the problem for me.  (Unless the partition is
>> mounted with mblk_io_submit.)
>>
>> Could you confirm that it fixes it for you as well?
>
> I believe I have applied the (relevant) inode.c changes to
> bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc, rebuilt and begun testing.
> Now at 28 passes without error, I think I can say that the patch
> appears to resolve the issue.
>
> --
> Jon
>

Confirmed !

I'm running my box for 5+ hours right now with your patch applied in
addition to Andi's/Milan's patch
(http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-scale-to-multiple-CPUs.patch)
, Ted, and can't see any indications of corruptions so far (while
doing an emerge -e system) and doing everyday stuff.
My /home partition (with ext4) is also still intact [which of course
has a backup] so it seems to fix it for me, too

so the corruption I was seeing was similar in a way to that of Jon

You can add a
Tested-by: Matthias Bayer <jackdachef@gmail.com>

Thanks a lot to everyone for your support ! :)


I have a question though: the deactivation of multiple page-io
submission support most likely only would affect bigger systems or
also desktop systems (like mine) ?

Regards

Matt
