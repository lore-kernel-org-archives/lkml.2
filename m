Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab2DPGix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:38:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34356 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2DPGiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:38:52 -0400
Date: Mon, 16 Apr 2012 08:38:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120416063838.GA23628@gmail.com>
References: <CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com>
 <CA+55aFwaOGbD6S_7So34ZuANG-6fZXZhEah8G0X7McDGhionSg@mail.gmail.com>
 <CAMP44s06jrPBzf5Lt86-GDxD_PxqcaeJgmYS4tJhcvDdf=J5zA@mail.gmail.com>
 <20120414104733.GA4871@gmail.com>
 <CAMP44s0tBbgmunXTN9Jyw=HHnXFyvRY3qo5Vf-jXETUM4HEGWA@mail.gmail.com>
 <20120415065124.GC29563@gmail.com>
 <CAMP44s3mOsCGG5_gd6zTUeXewTFKeVEmAkt2FvM=wTm-5AEC+w@mail.gmail.com>
 <CA+55aFz8oepgj7W8W=d18qwQt3JUGgv+pCto-_2WS3WJ3ZKqzQ@mail.gmail.com>
 <CAMP44s2vx5cn_=tRD46SqAobRceLiZDfi9-zLUnv_g89wLxryQ@mail.gmail.com>
 <20120416053911.GL27728@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416053911.GL27728@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> It's not the user's visibility, it's published code. Once code 
> is published, you cannot magically fix it without emitting a 
> new patch for this code and announcing so that users apply it. 
> These patches are called stable releases. Users want a good 
> reason to apply these patches, rebuild and reboot, and that's 
> one reason we absolutely want to have the commit descriptions 
> from upstream which detail the exact reason for the patch 
> (even if it's a revert).

Let me also outline why reverts are important and why they are 
not just 'a patch removed'.

A revert carries valuable information: we revert a broken commit 
not just with the terse description that it's broken, but with 
an exact description about *why* it's broken and how that 
breakage relates to the original patch.

In the limited 'patch space' nothing happened: a patch was done, 
then undone.

In the Git 'commit space' the picture is very different: we have 
a commit that does a change with a justification and we have 
*another* commit that undoes the code modification with 
*another* justification.

We got richer by two justifications and the kernel got
*more stable* in the process even though no actual code
changed:

 - We very likely won't repeat this mistake again, it's 
   documented for eternity to any developer touching this
   code in the future. See Linus's arguments about 'monotonic 
   progress'. Git hashes force the causality of the real 
   physical world on us, which is *especially* useful when we 
   make mistakes and would like to use a digital time machine 
   that whitewashes our shades of grey history.

 - In practice developers tend to be more careful with code that
   sees an above average ration of reverts. It's a red flag - it 
   shows that the code, the hardware or the development process 
   maintaining that code is somehow non-obvious and fragile for 
   one reason or another.

 - In most cases a change+revert also spurs further development: 
   the original justification is likely valid and people want to
   achieve that advantage but via some other, non-broken means. 
   In that sense the revert is a persistent TODO entry as well, 
   for developers.

If the bug was just a report somewhere in a mailing list archive 
on the web then it would bitrot quickly and people would not 
have a way to find it and react to it in an organized way.

By making it a Git commit; the change, the fix and all the 
justifications around it become a permanent part of Linux - 
which is more than just 15 million lines of code ...

Thanks,

	Ingo
