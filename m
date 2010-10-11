Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0JKQYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:24:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41749 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab0JKQYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bFz0qahr/SFcm4h8VOvrMtf1jZvSCcJDlJIoR/LMEW+wrSQF8Ou9raU+wBTzzQzWVJ
         UAYfGyn61cHDx/q6N8cd/IJr1cG7PxG1AidF3uYZ8uT4wen9b5i56h3Ez1MvSHF2sXVN
         UuaDvaYRqwVhT37WN6ffk4pJ4L6Cl9fCSxoq0=
MIME-Version: 1.0
In-Reply-To: <1286811979.9645.5.camel@ayu>
References: <AANLkTin8mAaHz_PypS9j4vQ35WozgD==U493e3OW_sy2@mail.gmail.com>
	<1286811979.9645.5.camel@ayu>
Date: Mon, 11 Oct 2010 11:24:16 -0500
Message-ID: <AANLkTinYz59U1hZd=C=zaTkJOvU93Vnb31bS1GkAHByA@mail.gmail.com>
Subject: Re: Horrible btrfs performance on cold cache
From: Chester <somethingsome2000@gmail.com>
To: Calvin Walton <calvin.walton@gmail.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think I read/heard somewhere that snapshots can cause pretty bad
fragmentation, because it causes your system to write changes to files
to random locations on the disk, leaving the original inodes intact..
For that reason, I have replaced the directories ~/.config/chromium ,
/var , /usr/portage with subvolumes, so they will not be included in
snapshots.

It seems like chromium opens much quicker now, but it's still a long
way from what it was on ext4

On Mon, Oct 11, 2010 at 10:46 AM, Calvin Walton <calvin.walton@gmail.com> wrote:
>
> On Mon, 2010-10-11 at 03:30 +0300, Felipe Contreras wrote:
> > Hi,
> >
> > I use btrfs on most of my volumes on my laptop, and I've always felt
> > booting was very slow, but definitely sure is slow, is starting up
> > Google Chrome:
> >
> > encrypted ext4: ~20s
> > btrfs: ~2:11s
> >
> > I have tried different things to find out exactly what is the issue,
> > but haven't quite found it yet.
>
> If you've been using this volume for a while, it could just have become
> badly fragmented. You could try btrfs's fancy online defragmentation
> abilities to see if that'll give you an improvement:
>
> # btrfs filesystem defragment /mountpoint/of/volume
>
> Let us know if that helps, of course :)
>
> --
> Calvin Walton <calvin.walton@gmail.com>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
