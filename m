Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2LDUv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:51:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61623 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2LDUv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:51:27 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1498848.rM1KKK5er8@al>
References: <20121203173951.GA25384@fancy-poultry.org>
	<CAKMK7uEGTWgPO-wf7aNLC+y9zLYPyy6f_djn6D-Gx-n6bFqcJA@mail.gmail.com>
	<20121204123522.GA32419@fritha.org>
	<1498848.rM1KKK5er8@al>
Date: Tue, 4 Dec 2012 21:51:25 +0100
X-Google-Sender-Auth: KXz4jCsCi0BCke2Tya7-lqwAZwk
Message-ID: <CAKMK7uHH8U64w5kWVp1oOnhTHkStGoJHJx1KazCQ2-gaCAm0Sg@mail.gmail.com>
Subject: Re: i915 freakout with latest 3.7 git
From: Daniel Vetter <daniel@ffwll.ch>
To: Lekensteyn <lekensteyn@gmail.com>
Cc: dri-devel@lists.freedesktop.org, Heinz Diehl <htd@fritha.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Heinz Diehl <htd@fancy-poultry.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 9:41 PM, Lekensteyn <lekensteyn@gmail.com> wrote:
> On Tuesday 04 December 2012 13:35:22 Heinz Diehl wrote:
>> Btw: which kernel is known to be the "last good one"?
> As mentioned in the linked bug [1], I bisected it to:
>
> commit 504c7267a1e84b157cbd7e9c1b805e1bc0c2c846
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Thu Aug 23 13:12:52 2012 +0100
>
>     drm/i915: Use cpu relocations if the object is in the GTT but not mappable

Iirc your issue goes away with rc6=0, the residual bugs we still have
all still happen with rc6 disable, so probably something else. Hence
also why we're asking everyone who can still reproduce to try a
bisect, since with rc6 disabled we've can't reproduce the hang any
more (beforehand we could reproduce it on 3 different ilk machines).
The important part is to not enable rc6 (on ironlake at least) when
bisecting.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
