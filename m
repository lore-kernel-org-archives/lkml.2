Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab1FPW7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 18:59:30 -0400
Received: from mail03-md.ns.itscom.net ([175.177.155.113]:53908 "EHLO
	mail03-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758489Ab1FPW72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 18:59:28 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Erez Zadok <ezk@fsl.cs.sunysb.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "viro\@ZenIV.linux.org.uk Viro" <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com
In-Reply-To: <87hb7piwrl.fsf@tucsk.pomaz.szeredi.hu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <4540f7aa16724111bd792a1d577261c2@HUBCAS1.cs.stonybrook.edu> <954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu> <12728.1308237302@jrobl> <87hb7piwrl.fsf@tucsk.pomaz.szeredi.hu>
Date: Fri, 17 Jun 2011 07:59:26 +0900
Message-ID: <15802.1308265166@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> file, so most applications should handle this behavior fine.  The truth
> is a bit more complicated and the effect of the copy-up is more like
> this:
>
>    cp /foo/bar /tmp/ttt
>    mount --bind /tmp/ttt /foo/bar

Good example.
'mount' instead of simple 'cp' means struct stat.st_dev differs.
And it will make some applications confused such as find -x, du -x, df,
chmod/own -R, rm -r, or etc.


> The credentials of the current task are not modified but replaced by
> new, temporary credentials.  This will only have an affect on a single
> thread.

I see.
I think I can understand about multi threads. Other threads will not be
affected. I will test about a signal handler someday.


J. R. Okajima
