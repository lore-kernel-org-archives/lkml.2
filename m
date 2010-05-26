Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab0EZRsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:48:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754822Ab0EZRsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:48:45 -0400
Date: Wed, 26 May 2010 10:45:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning in Linus'tree
In-Reply-To: <OFE9F7159D.A4D62F91-ONC125772F.005CB786-C125772F.00603B6C@transmode.se>
Message-ID: <alpine.LFD.2.00.1005261036550.3689@i5.linux-foundation.org>
References: <20100526110506.f2f4f22c.sfr@canb.auug.org.au> <20100525182040.f1882d0a.akpm@linux-foundation.org> <20100526140900.5b091c16.sfr@canb.auug.org.au> <OFC00BDFAC.5596A841-ONC125772F.0022984D-C125772F.0023AF14@transmode.se>
 <20100525234116.71889c71.akpm@linux-foundation.org> <20100526171424.447fac18.sfr@canb.auug.org.au> <OFE5212A1C.B62E8E51-ONC125772F.00371EE7-C125772F.0038EEC8@transmode.se> <alpine.LFD.2.00.1005260828320.3689@i5.linux-foundation.org>
 <OF6B2D521C.109F3133-ONC125772F.00576DF0-C125772F.005B18F3@transmode.se> <alpine.LFD.2.00.1005260939030.3689@i5.linux-foundation.org> <OFE9F7159D.A4D62F91-ONC125772F.005CB786-C125772F.00603B6C@transmode.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 May 2010, Joakim Tjernlund wrote:
> >
> > So no. The glibc model is _not_ any better in practice.
> 
> In the kernel it is since it breaks the compile. The breakage
> my patch introduced is a sign of that, right?

In the kernel it is _worse_, because it breaks all the years and years of 
code we have. 

The thing is, "reality" > "theory".

Besides, the kernel model is a lot denser, more straightforward, and in my 
opinion much less likely to cause problems due to having just two clear 
identifiers rather than that extraneous and useless __BYTE_ORDER one.

So even in theory, I don't agree. It's not like we've really had problems 
with our model.

> hmm, so then I guess the existing use of __BYTE_ORDER in the
> kernel should be removed?

Yes. Except in the places where it exists solely due to user-space header 
exporting (and there it generally is a big hint that something is wrong 
anyway, as mentioned). From my quick grep (read: "not verified") there's a 
couple of files like that.

It's probably not worth trying to change (one of them is about 
__BIG_ENDIAN_BITFIELD, which is due to people using bitfields for 
transferring data. That _is_ misdesigned. Bitfield ordering is even less 
well defined than byte order, and if you have to use those bitfield 
ordering things, it's almost always a sign that you shouldn't have used 
bitfields, and used explicit shifts-and-masks instead)

		Linus
