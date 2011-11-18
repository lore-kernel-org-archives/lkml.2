Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab1KREqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 23:46:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61375 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab1KREqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 23:46:22 -0500
Date: Fri, 18 Nov 2011 12:45:15 +0800
From: wangyanqing <udknight@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: torvalds@linux-foundation.org, castet.matthieu@free.fr,
        akpm@linux-foundation.org, x86@kernel.org, spock@gentoo.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: remove NX from video bios area
Message-ID: <20111118044515.GA17250@udknight.homenetwork>
Mail-Followup-To: wangyanqing <Udknight@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org,
	castet.matthieu@free.fr, akpm@linux-foundation.org, x86@kernel.org,
	spock@gentoo.org, linux-kernel@vger.kernel.org
References: <20111117082624.GA4136@udknight.homenetwork>
 <4EC520AE.3070409@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC520AE.3070409@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 06:56:46AM -0800, H. Peter Anvin wrote:
> On 11/17/2011 12:26 AM, wangyanqing wrote:
> >  
> > +/*we hope this the right video bios range*/
> > +#define VIDEO_BIOS_BEGIN	0x000c0000
> > +#define VIDEO_BIOS_END		0x000c7fff
> > +
> >  #define BIOS_ROM_BASE		0xffe00000
> >  #define BIOS_ROM_END		0xffffffff
> 
> Ick.  This feels increasingly hacky, especially since the above is known
> to not be the video BIOS range on a lot of reasons.
> 
> There is something much more fundamentally wrong here, including why X
> permission is needed for uvesafb at all.
> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
Sorry for my bad idea!
Indeed v86d have double backend to execute x86 video bios code,
one is lrmi(linux real mode interface), another is x86emu.Yesterday,
I compile the v86d with x86emu.Below is the new maps:

08048000-0805e000 r-xp 00000000 00:01 3324       /sbin/v86d 
0805e000-0805f000 rw-p 00015000 00:01 3324       /sbin/v86d 
0805f000-08060000 rw-p 00000000 00:00 0 
b7713000-b7733000 rw-s 000e0000 00:01 3234       /dev/mem 
b7733000-b7742000 rw-s 000c0000 00:01 3234       /dev/mem 
b7742000-b7762000 rw-s 000a0000 00:01 3234       /dev/mem 
b7762000-b7763000 rw-s 0009c000 00:01 3234       /dev/mem 
b7763000-b7764000 rw-s 00000000 00:01 3234       /dev/mem 
b7764000-b7784000 rw-p 00000000 00:01 3230       /dev/zero
b7784000-b7785000 r-xp 00000000 00:00 0          [vdso]
bf98a000-bf9ab000 rw-p 00000000 00:00 0          [stack]

As you see,  now v86d doesn't need the X permission.But 
my machine still hang very early(verbose show uvesafb some 
messages, then black screen, it hangs!)

But if I make the BIOS range X unconditionally, the problem is gone.
So we need more hacky.Any comment is welcome.

Sorry again for the bad patch "[PATCH v2] x86: remove NX from video bios area",
it even can't compile, and it also can't solve myself problem, I haven't test it 
before send it out, I willn't make the same mistake again.

Thanks for all you time.

