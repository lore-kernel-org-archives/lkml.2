Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab1FQHjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 03:39:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46227 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab1FQHi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 03:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=Vrz+amRbk1tfwdZfensEBHU35jQIUHgb9YbNODzBtHNbs7HdemjWO7Z7TqykCTPYD5
         J8csTmEHQgNisw4OUy9NQwfahnu3S9rFQc6HGejfWs6K38jwStQfBGxCj2lQP2ldfS06
         /C8Em3DRAVK1bIKn+X4qTx1Usk3XJ+Mqp+Bio=
MIME-Version: 1.0
In-Reply-To: <12737.1308237353@jrobl>
References: <20110609125114.8dff08da.akpm@linux-foundation.org>
 <BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com> <20110610100143.28037551@lxorguk.ukuu.org.uk>
 <8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu> <11186.1308148376@jrobl>
 <87vcw7hz7y.fsf@tucsk.pomaz.szeredi.hu> <15402.1308154495@jrobl>
 <BANLkTi=hvBBbZPBj5niUV9StSRRjmLtK8w@mail.gmail.com> <18273.1308192226@jrobl>
 <BANLkTimhL5BG9gHOG0Fr9U5fLkE0NJvpng@mail.gmail.com> <12737.1308237353@jrobl>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Fri, 17 Jun 2011 09:38:37 +0200
X-Google-Sender-Auth: HO1i-pMCKe0ZqE5vtkTOT5ZUubc
Message-ID: <BANLkTi=6hKExj-LrOPBBhF4ym_YZNVG3Sg@mail.gmail.com>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valerie Aurora <val@vaaconsulting.com>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 June 2011 17:15, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> Michal Suchanek:
>> Probably swap the two above, you can't make a whiteout in presence of
>> the directory, right?
>> Anyway, you could just mark dirA as whiteout and remove any whiteouts
>> contained in it asynchronously, and only jump through these hoops when
>> trying to create a new entry in place of non-empty whiteout, or sync
>> on emptying the old whiteout before making a new entry.
>
> Unfortunately I cannot understand what you wrote.
>
> First, the order of
>> - create whiteout for dirA
>> - rename dirA to .wh..wh.XXXXXXXX
> is correct and I think it should be, in order to make a little help for

Yes, it's correct for aufs which uses reserved file names for whiteouts.

Filesystems that don't reserve filenames cannot make whiteout for an
existing entry but aufs can.

> fsck/auchk.
> And what is "non-empty whiteout" and "emptying the old whiteout"?
> The whiteout is a size zero-ed and hardlinked regular file in aufs.

Is there any reason why a directory cannot be whiteout?

>
>
>> Yes, it can only cause pollution with whiteouts unrelated to any files
>> that ever existed which is not too much of an issue unless people want
>> to add random stuff to the lower layer and see it in the union when
>> they reconstruct it again.
>
> ??
> Do you think that the .wh..wh.XXXXXXXX hides something on the lower
> layer? If so, it is wrong. Such doubly whiteout hides nothing except
> itself.

It may possibly hide a XXXXXXXX file if it is later added to the lower layer.

But if .wh.XXXXXXXX is in itself a reserved filename that is never
brought up from the lower layer then this is a non-issue, it works
consistently regardless of existence of the superfluous whiteout.

>
>
>> It is only valid when in the upper layer of a union. However, so is
>> whiteout, and so are files that were visible in the union but are not
>> visible in the top layer if examined separately, outside of the union.
>
> Do you mean that your special symlink has totally different file-type
> from a symlink?

Just as whiteout has totally different file-type from a file. It's
specific to the union.

> Anyway what I want to say is, what such symlink refers may differ
> from what users originally expect. But I may misunderstand what you call
> "fallthru symlink".

How is this different from other files that are taken from the lower
layer and not copied into the upper layer?

If you are concerned about that you want a full copy, not a union.

Thanks

Michal
