Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2LDWVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 17:21:44 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46926 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2LDWVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 17:21:34 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <2102240.hdkK7C4k4g@al>
References: <20121203173951.GA25384@fancy-poultry.org>
	<1498848.rM1KKK5er8@al>
	<20121204210845.GA2092@fritha.org>
	<2102240.hdkK7C4k4g@al>
Date: Tue, 4 Dec 2012 23:21:32 +0100
X-Google-Sender-Auth: sacHu_SzbZrABo8JP-yzLaYTtuc
Message-ID: <CAKMK7uEaT1H0DUszYqxbp_8WdLWs2quQbSJVqir0eAibYKvN+A@mail.gmail.com>
Subject: Re: i915 freakout with latest 3.7 git
From: Daniel Vetter <daniel@ffwll.ch>
To: Lekensteyn <lekensteyn@gmail.com>
Cc: Heinz Diehl <htd@fritha.org>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Heinz Diehl <htd@fancy-poultry.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 4, 2012 at 11:09 PM, Lekensteyn <lekensteyn@gmail.com> wrote:
> On Tuesday 04 December 2012 22:08:45 Heinz Diehl wrote:
>> Ok, but in comment 11 in the same thread you mention that reverting
>> this patch didn't fix the issue for you:
>>
>> "Reverting that commit on top of 3.7-rc4 did not fix the hang issue."
> The bisected commit was from between rc2 and rc3:
> $ git describe 504c7267a1e84b157cbd7e9c1b805e1bc0c2c846
> v3.6-rc2-88-g504c726

This just means that after -rc2 there are 88 patches until 504c72.
This doesn't mean at all that this patch is included in -rc3 - git
history is non-linear! In fact this commit is only part of the 3.7-rc1
release, so if you just update Linus' tree it will have shown up
somewhere between the 3.6 and 3.7-rc1 tag being pushed out.

> The fact that reverting that commit does not help implies that some commits
> thereafter also expose the bug.

Well, enabling rc6 was merge before the offending commit but still
works around at least a class of bugs. So it's very likely that we're
just hunting down different strawmens ...

>> > i915.i915_enable_rc6=0 worked for me, if it does not work for you, then
>> > you  probably hit another bug.
>>
>> I have now i915.i915_enable_rc6=0 in grub.cfg and disabled the XFCE
>> compositor. Now I'm trying to hit the bug again...
> Do you have a reliable reproduce method? As you can see in the linked bug it
> was caused by relatively low memory pressure combined with high I/O (caching?
> delays? Who knows).

Nope, we could only reproduce quickly with rc6 enabled :(
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
