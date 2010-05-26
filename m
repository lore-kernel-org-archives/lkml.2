Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab0EZQiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:38:09 -0400
Received: from gw1.transmode.se ([213.115.205.20]:50768 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab0EZQiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:38:07 -0400
In-Reply-To: <alpine.LFD.2.00.1005260828320.3689@i5.linux-foundation.org>
References: <20100526110506.f2f4f22c.sfr@canb.auug.org.au> <20100525182040.f1882d0a.akpm@linux-foundation.org> <20100526140900.5b091c16.sfr@canb.auug.org.au> <OFC00BDFAC.5596A841-ONC125772F.0022984D-C125772F.0023AF14@transmode.se> <20100525234116.71889c71.akpm@linux-foundation.org> <20100526171424.447fac18.sfr@canb.auug.org.au> <OFE5212A1C.B62E8E51-ONC125772F.00371EE7-C125772F.0038EEC8@transmode.se> <alpine.LFD.2.00.1005260828320.3689@i5.linux-foundation.org>
Subject: Re: linux-next: build warning in Linus'tree
X-KeepSent: 6B2D521C:109F3133-C125772F:00576DF0;
 type=4; name=$KeepSent
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OF6B2D521C.109F3133-ONC125772F.00576DF0-C125772F.005B18F3@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 26 May 2010 18:35:01 +0200
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-05-26 18:38:04
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote on 2010/05/26 17:29:02:
>
> On Wed, 26 May 2010, Joakim Tjernlund wrote:
> >
> > If my suggestion above works, then one could start transforming current uses
> of __BYTE_ORDER,
> > into similar constructs and once all are done, #define both __LITTLE_ENDIAN/
> __BIG_ENDIAN and
> > move back to #if __BYTE_ORDER == __LITTLE_ENDIAN
>
> No. Don't do it. Why the hell would we want to use the inferior model?

I agree that the glibc model(dunno if this is glibc/gcc specific or some standard)
is less than optimal but the linux model has two major flaws too:

1) It silently breaks when neither of {__LITTLE_,__BIG}_ENDIAN (or both)are
   defined depending on the endianess of the target CPU.
   The glibc model generates a compile error if you forget to include __BYTE_ORDER.

2) It clashes with user space so one cannot use it in exported header files.

If you grep for __BYTE_ORDER in the kernel you will find some ugly #ifdefs
to overcome 2). It would have been somewhat better if linux had defined its own
names instead of reusing the glibc/gcc names with different semantics.

1) is worse and the reason for this patch. I moved lib/crc32.c
to user space so I could run the builtin unit test program because
I wanted to do some optimizations. It just silently broke depending
on the endianess of the CPU. Took half a day to figure out why :(
This could easily happen in the kernel too.

 Jocke

