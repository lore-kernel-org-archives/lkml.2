Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab0F3Em0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 00:42:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53196 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0F3EmZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 00:42:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YQGd/B7jxM+9WU4vbG+XhTMEtT35ucE9Q9TzUoHFqawKuBrIkfMkIbIxaP1ExxdXHL
         wlKXHnn4bqGyXPf2KT7Azz2I9qVb53k1PVUR9jitAL7mrdLNdZT+IYjF9sNd5m/lfc8E
         /+1QOcRnK7S7yW3j2VIJjLyHtvf75uRt22Y54=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
References: <alpine.DEB.2.00.1006300202190.30052@skynet.skynet.ie>
Date: Wed, 30 Jun 2010 06:42:23 +0200
Message-ID: <AANLkTinjPWOWzoY122lQrEqtSN-hzfnOfy2svx4LELl2@mail.gmail.com>
Subject: Re: [git pull] drm fixes + agp + one fb patch
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/30 Dave Airlie <airlied@linux.ie>:
> Hi Linus,
>
> one fb layer fix in a flag I introduced,
>
> the rest are drm fixes:
> radeon fixes: the larger ones in the command stream checker for older cards,
> which was causing a lot of userspace apps to fail. Also some powerpc server fixes.
> along with some updates to the evergreen command stream checker introduced in -rc1.
>
> agp: fix issue with warning on memory allocation + fallback to vmalloc.
> ttm: fix regression introduced in -rc1 in memory allocation paths.

Dave, could you queue
[PATCH] drm/radeon/kms/pm: fix power state indexing on igp chips in dynpm mode
for next (still .35) drm pull request?

It fixes FDO bug https://bugs.freedesktop.org/show_bug.cgi?id=28745 ,
div by zero which actually I consider a regression since:
1) In .34 I was able to use radeon.dynpm=1
2) In .35-rc div by zero + lockup on echo dynpm > /sys/devices/.../power_method

-- 
Rafał
