Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab2LDH0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:26:08 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50882 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2LDH0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:26:06 -0500
Date: Tue, 4 Dec 2012 08:26:04 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [YASB] Re: Linux 3.7-rc7
Message-ID: <20121204072604.GA7467@rhlx01.hs-esslingen.de>
References: <CA+55aFyetqyMa2BQu7kE=cqFdAysUh9gV=O5as5Chgg1EMCW7g@mail.gmail.com>
 <20121203193310.GA32762@rhlx01.hs-esslingen.de>
 <CA+55aFygWCxz=Mmogp8FoSr51rNct6ANw0Kw3y=u4Pu2iDK48Q@mail.gmail.com>
 <20121203194817.GA14594@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203194817.GA14594@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 03, 2012 at 08:48:17PM +0100, Andreas Mohr wrote:
> Will try script to unload half of all drivers etc.
> (heavy amounts of bisection wouldn't be joyful on this box).
> 
> 
> I failed to mention the effects:
> Suspend starts, disk does spin down, yet display backlight stays
> until finally monitor blanks.

Unloading *all* unloadable modules didn't help.

Current status:

$ git bisect log
git bisect start
# good: [f4a75d2eb7b1e2206094b901be09adb31ba63681] Linux 3.7-rc6
git bisect good f4a75d2eb7b1e2206094b901be09adb31ba63681
# bad: [3c46f3d6406b1d0c53575774b2d1fd013cd7f76f] Merge branch
# 'for-3.7-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
git bisect bad 3c46f3d6406b1d0c53575774b2d1fd013cd7f76f
# good: [35f95d228e55eebdc87b5c0dbdecc46884f476a6] Merge tag
# 'for-linus-20121123' of git://git.infradead.org/mtd-2.6
git bisect good 35f95d228e55eebdc87b5c0dbdecc46884f476a6
# good: [e9296e89b85604862bd9ec2d54dc43edad775c0d] Merge
# git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good e9296e89b85604862bd9ec2d54dc43edad775c0d


Currently processing a95251b8bac4a91a43db795a7193545dac65f4f4 .


So far everything in the normal, no interim (build) breakage etc.

Andreas Mohr
