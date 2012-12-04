Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2LDWKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 17:10:05 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:44241 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab2LDWKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 17:10:02 -0500
From: Lekensteyn <lekensteyn@gmail.com>
To: Heinz Diehl <htd@fritha.org>
Cc: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Heinz Diehl <htd@fancy-poultry.org>
Subject: Re: i915 freakout with latest 3.7 git
Date: Tue, 04 Dec 2012 23:09:58 +0100
Message-ID: <2102240.hdkK7C4k4g@al>
User-Agent: KMail/4.9.3 (Linux/3.7.0-1-custom; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121204210845.GA2092@fritha.org>
References: <20121203173951.GA25384@fancy-poultry.org> <1498848.rM1KKK5er8@al> <20121204210845.GA2092@fritha.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2012 22:08:45 Heinz Diehl wrote:
> Ok, but in comment 11 in the same thread you mention that reverting
> this patch didn't fix the issue for you:
> 
> "Reverting that commit on top of 3.7-rc4 did not fix the hang issue."
The bisected commit was from between rc2 and rc3:
$ git describe 504c7267a1e84b157cbd7e9c1b805e1bc0c2c846
v3.6-rc2-88-g504c726
The fact that reverting that commit does not help implies that some commits 
thereafter also expose the bug.

> > i915.i915_enable_rc6=0 worked for me, if it does not work for you, then
> > you  probably hit another bug.
> 
> I have now i915.i915_enable_rc6=0 in grub.cfg and disabled the XFCE
> compositor. Now I'm trying to hit the bug again...
Do you have a reliable reproduce method? As you can see in the linked bug it 
was caused by relatively low memory pressure combined with high I/O (caching? 
delays? Who knows).

> A shot in the dark: could it be that all the machines wich encounter
> this hang have nvidia's optimus? Mine has. Could that somehow be
> related? (I'm by no means a programmer or a kernel hacker..).
It is unlikely that Optimus has anything to do with this.

Peter
