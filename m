Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2LDVIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 16:08:54 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50746 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab2LDVIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 16:08:50 -0500
Date: Tue, 4 Dec 2012 22:08:45 +0100
From: Heinz Diehl <htd@fritha.org>
To: Lekensteyn <lekensteyn@gmail.com>
Cc: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Heinz Diehl <htd@fancy-poultry.org>
Subject: Re: i915 freakout with latest 3.7 git
Message-ID: <20121204210845.GA2092@fritha.org>
References: <20121203173951.GA25384@fancy-poultry.org>
 <CAKMK7uEGTWgPO-wf7aNLC+y9zLYPyy6f_djn6D-Gx-n6bFqcJA@mail.gmail.com>
 <20121204123522.GA32419@fritha.org>
 <1498848.rM1KKK5er8@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1498848.rM1KKK5er8@al>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+67 (d414971f0c48) (2011-07-01)
X-Provags-ID: V02:K0:AVGm86Tv20UYavMkowwwG4hUyBd/3vS4X0DFIFcVEF8
 HnYtM2K4XYqPFbzZfi+rZgyYctnfICnogfpRQp4bHtqLcBdEV2
 K5jxjRFc/ebFpYBd6VHkBjCRfI5DzU/W3LE574cMmsBewVULks
 15tQk7G5PawdtZW+SfJVVXW/U0kKSJ/Qvy6O/eVpkAtIAPDJSm
 PPJM5MoWF6XKh6N+zBRZkV4zxZ9MGhS/tCxXYIZa0dHzX+qkZ3
 nGTFif0kUtLOMcreRYaaunl8ltACR5O/iMvFAy4vC6Wahtu9Tv
 TE/3F5dMGN6gE98nDf3X7umoX7aPT/IRHwXpyEf9JWqfpnYp82
 +4BKTqJLFvU7CCmWNZbWU7AnP6gwrN/sdnk9TvOKL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.12.2012, Lekensteyn wrote: 

> As mentioned in the linked bug [1], I bisected it to:
> 
> commit 504c7267a1e84b157cbd7e9c1b805e1bc0c2c846
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Thu Aug 23 13:12:52 2012 +0100
> 
>     drm/i915: Use cpu relocations if the object is in the GTT but not mappable

Ok, but in comment 11 in the same thread you mention that reverting
this patch didn't fix the issue for you:

"Reverting that commit on top of 3.7-rc4 did not fix the hang issue."

> i5-420M is not SB, but ILK. i5-2xxx is SB. I have a i5-460M myself. 

Yes, you're right, my bad! Don't know what I was thinking as I wrote that. I
don't have any i5-420M either, but an i5-450M. It was clearly not my
day..

[htd@wildsau ~]$ cat /proc/cpuinfo | grep model
model	     	 : 37
model name	 : Intel(R) Core(TM) i5 CPU       M 450  @ 2.40GHz
[....]

> i915.i915_enable_rc6=0 worked for me, if it does not work for you, then you 
> probably hit another bug.

I have now i915.i915_enable_rc6=0 in grub.cfg and disabled the XFCE
compositor. Now I'm trying to hit the bug again...

Heinz
