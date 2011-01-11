Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab1AKQ0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:26:04 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39527 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab1AKQ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:26:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KhSEzWme8MbhdvULkWNBumneV6Fxkqfb1iRlyJD93ephqf1IwAZsV9TsGMmiZqGWMq
         TOvAEidvTfmS6cRWi5BUqbvHYXqUaQQueEf7LkXB5DGr8Y6laLLcxU8V9TsVHf8QSfM9
         tVISyxGICQLNltlyj2oU4x81pzTnVupn+ps98=
MIME-Version: 1.0
In-Reply-To: <AANLkTimx0hWByYw1dXKS6y0B9a84gYOxBu-Gnjm+cCwa@mail.gmail.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
	<AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
	<AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
	<0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com>
	<AANLkTim0rn7Vem6YJM5tVKM0PX4YdnNmaeqmpS=Vp7rc@mail.gmail.com>
	<AANLkTimx0hWByYw1dXKS6y0B9a84gYOxBu-Gnjm+cCwa@mail.gmail.com>
Date: Tue, 11 Jan 2011 18:25:59 +0200
Message-ID: <AANLkTiknirXaqkvR4DoA34Te=Dj8kentQynrP-Dn=Dk8@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@gmail.com>,
        Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 6:11 PM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
> Linus, 2.6.37-git4 works for me, can you unpull the DRM, and wait
> until is more stable ?

What I have done:
git bisect log
git bisect start
# bad: [5b2eef966cb2ae307aa4ef1767f7307774bc96ca] Merge branch
'drm-core-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
git bisect bad 5b2eef966cb2ae307aa4ef1767f7307774bc96ca
# good: [3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5] Linux 2.6.37
git bisect good 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5
# good: [c413521eb4e2d7ffd5ce432a144708d479054bd3] ARM: mach-shmobile:
update for SMP changes.
git bisect good c413521eb4e2d7ffd5ce432a144708d479054bd3
# bad: [78c92a9fd4b6abbbc1fe1ec335c697cb4e63f252] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6
git bisect bad 78c92a9fd4b6abbbc1fe1ec335c697cb4e63f252
# bad: [da40d036fd716f0efb2917076220814b1e927ae1] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
git bisect bad da40d036fd716f0efb2917076220814b1e927ae1
# bad: [dc69d1af9e8d9cbbabff88bb35a6782187a22229] omap2: Make
OMAP2PLUS select OMAP_DM_TIMER
git bisect bad dc69d1af9e8d9cbbabff88bb35a6782187a22229

Second bisect bad: nouveau not loaded, but I have an usable system.
I don't feel I'm doing it right.
