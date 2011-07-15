Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab1GONGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 09:06:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44474 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab1GONGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 09:06:50 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
	<20110609115934.3c53f78f@notabene.brown>
	<20110608205233.ebfedc4d.akpm@linux-foundation.org>
	<87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu>
	<20110609123843.77153b27.akpm@linux-foundation.org>
	<877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu> <21324.1307677721@jrobl>
	<871uyxa7ol.fsf@tucsk.pomaz.szeredi.hu>
	<8739ig3k93.fsf@tucsk.pomaz.szeredi.hu> <8536.1310214135@jrobl>
	<87k4bjd8pc.fsf@tucsk.pomaz.szeredi.hu> <12864.1310734928@jrobl>
Date: Fri, 15 Jul 2011 15:07:47 +0200
In-Reply-To: <12864.1310734928@jrobl> (J. R. Okajima's message of "Fri, 15 Jul
	2011 22:02:08 +0900")
Message-ID: <87fwm7d74s.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. R. Okajima" <hooanon05@yahoo.co.jp> writes:

> Miklos Szeredi:
>> st_nlink==1 for directories is widely accepted way of saying that the
>> number of subdirectories is unknown.  Various filesystems already do
>> this, and versions of GNU utils that I have come across accept it.
>
> When the upperdir is tmpfs, the link count of the directories in it will
> not be 1, won't it?

In overlayfs directory will have a link count of one if it's a "merged"
directory, regardless of the filesystem types used.  If it's not a
merged directory, then st_nlink will correctly refrect the number of
subdirs.

>> I hadn't thought about this case, so overlayfs would modify the lower
>> filesystem in that case, which is a no-no.
>>
>> Following patch fixes this and return -EROFS for the above case.  I also
>> updated the non-standard section in the docs.
>
> Hmm, such changes to mnt_flags looks slightly rude to me. Do we have to
> consider about these?
> - there may exist files opened as RW on the lower.
> - when overlayfs is unmounted, it should restore the original mnt_flags.
> - (there may exist more...)
>
> If overlayfs doesn't expect the lower mounted as RW, then it might be
> better to reject it simply at mounting.

Overlayfs will create a private clone of both the lower and upper
mounts.  The mnt_flags are only modified on the private clone, whose
sole user is overlayfs itself.

Thanks,
Miklos
