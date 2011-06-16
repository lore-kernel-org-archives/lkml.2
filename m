Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1FPPP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:15:59 -0400
Received: from mail04-md.ns.itscom.net ([175.177.155.114]:39895 "EHLO
	mail04-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab1FPPPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:15:55 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valerie Aurora <val@vaaconsulting.com>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
In-Reply-To: <BANLkTimhL5BG9gHOG0Fr9U5fLkE0NJvpng@mail.gmail.com>
References: <20110609125114.8dff08da.akpm@linux-foundation.org> <BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com> <20110610100143.28037551@lxorguk.ukuu.org.uk> <8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu> <11186.1308148376@jrobl> <87vcw7hz7y.fsf@tucsk.pomaz.szeredi.hu> <15402.1308154495@jrobl> <BANLkTi=hvBBbZPBj5niUV9StSRRjmLtK8w@mail.gmail.com> <18273.1308192226@jrobl> <BANLkTimhL5BG9gHOG0Fr9U5fLkE0NJvpng@mail.gmail.com>
Date: Fri, 17 Jun 2011 00:15:53 +0900
Message-ID: <12737.1308237353@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Michal Suchanek:
> Probably swap the two above, you can't make a whiteout in presence of
> the directory, right?
> Anyway, you could just mark dirA as whiteout and remove any whiteouts
> contained in it asynchronously, and only jump through these hoops when
> trying to create a new entry in place of non-empty whiteout, or sync
> on emptying the old whiteout before making a new entry.

Unfortunately I cannot understand what you wrote.

First, the order of
> - create whiteout for dirA
> - rename dirA to .wh..wh.XXXXXXXX
is correct and I think it should be, in order to make a little help for
fsck/auchk.
And what is "non-empty whiteout" and "emptying the old whiteout"?
The whiteout is a size zero-ed and hardlinked regular file in aufs.


> Yes, it can only cause pollution with whiteouts unrelated to any files
> that ever existed which is not too much of an issue unless people want
> to add random stuff to the lower layer and see it in the union when
> they reconstruct it again.

??
Do you think that the .wh..wh.XXXXXXXX hides something on the lower
layer? If so, it is wrong. Such doubly whiteout hides nothing except
itself.


> It is only valid when in the upper layer of a union. However, so is
> whiteout, and so are files that were visible in the union but are not
> visible in the top layer if examined separately, outside of the union.

Do you mean that your special symlink has totally different file-type
from a symlink?
Anyway what I want to say is, what such symlink refers may differ
from what users originally expect. But I may misunderstand what you call
"fallthru symlink".


J. R. Okajima
