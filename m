Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab2HOEol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 00:44:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51599 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2HOEoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 00:44:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120814132506.GB7122@quack.suse.cz>
References: <1342868717-1712-1-git-send-email-ashish.sangwan2@gmail.com>
	<20120814132506.GB7122@quack.suse.cz>
Date: Wed, 15 Aug 2012 10:14:38 +0530
Message-ID: <CAOiN93=Wrd8Mph-u1HusZ1SGNqR1r=fkkMe7RSANajdvW-ew4Q@mail.gmail.com>
Subject: Re: [PATCH] UDF: During mount free lvid_bh before rescanning with
 different blocksize
From: Ashish Sangwan <ashishsangwan2@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ashish Sangwan <ashish.sangwan2@gmail.com>,
        Namjae Jeon <linkinjeon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

>   Yeah, I don't think this happens in practice but in theory it could. BTW,
> did you check whether we don't need to free other information (like VAT
> inode etc.) when rescanning the filesystem? I think we do but currently I'm
> catching up after a long vacation and this doesn't have high priority.
>
Actually, it did happen in practice. That's how we discovered it.
Currently, it seems a bug.
We formatted a usb stick, sector size 512bytes, using mkudffs with
default block size 2KB.
While writing to this media we unplug the USB which left lvid in
corrupted state.
On remounting, first UDF tries to mount the media with sector size and
somehow it managed to fill lvid bh
but failed to load metadata/mirror fe because of wrong block size.
While rescanning with 2KB block size it failed to load the correct
lvid as it was corrupted earlier
and ended up using the wrong one.
After noticing this problem, we did check other info too. Everything
else seems to be correct.

> Anyway, I've added your patch to my tree. Thanks.
>
 Thanks for looking into the patch.

Ashish
