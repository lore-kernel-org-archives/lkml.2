Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1DVVw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:52:26 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:48580 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756785Ab1DVVwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:52:21 -0400
Subject: Re: End of FAT directories
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: dosfstools <daniel@debian.org>, mtools <Alain@linux.lu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <87hb9qnho4.fsf@devron.myhome.or.jp>
References: <1303498136.8485.128.camel@localhost>
	 <87hb9qnho4.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Apr 2011 23:56:48 +0200
Message-ID: <1303509408.8485.146.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 87.123.66.109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 23.04.2011, 05:40 +0900 schrieb OGAWA Hirofumi:


> It is simply the bug of Sony devices, and can't work on it for both of
> Windows and Linux (it have to be fixed by fsck).
You are right. Although as the sony device *does* clear out the first 8K
of the 16K cluster, that makes 256 correctly working directory entries.
This directory is only used for storing a dozen of files with no long
names, the existing problem you correctly describe is not relevant in
practice.

> Assume 0-3 directory entires fine, 4 is zeroed entry, and 5- is crappy data.
> 
> 1| ENT1        valid
> 2| ENT2        valid
> 3| ENT3        valid
> 4|             zeroed
> 5| djafdjoi    crappy data
> ...
> 
> Windows will stop at 4, but if windows write new entry as 4, 5- will
> show those up as crap like linux.
You are right. Thanks for your input. This means Windows and mtools
behave exactly the same way (and thus mtools can not really be
considered buggy). I expected Windows to fix up the end, but it does
not.

I still would prefer greatly if Windows and Linux at least read media
the same way (i.e. stop on the first zeroed entry), I even have a patch
for that somewhere around I can dig out.
I furthermore think it is quite important for dosfsck and the linux
kernel to behave consistent (think of valid entries after the zeroed
entry linking to "lost clusters"). If I prepare patches for the Linux
kernel to
 - terminate reading at the first zeroed entry
 - making sure that if a zeroed entry gets populated, the next entry
gets zeroed unless we hit the end of the directory (deviating from
Windows behaviour, intentionally, to keep the filesystem consistent)
And for dosfsck to
 - terminate reading at the first zeroed entry
 - offer filling the remainder of a directory cluster with zero bytes.
Would this set of patches be acceptable?


> In short, in spec, directory must be initialized by
> zero (it is same assumption on linux and windows).
Turns out you are right. Sorry for making the implicit assumption that
windows handles the case better.

Regards,
  Michael Karcher

