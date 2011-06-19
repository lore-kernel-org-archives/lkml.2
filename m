Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1FSXOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 19:14:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39227 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab1FSXOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 19:14:04 -0400
Date: Mon, 20 Jun 2011 01:14:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, torvalds@linux-foundation.org, mroos@linux.ee,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: reorganized struct inode results in unaligned accesses
Message-ID: <20110619231402.GK16236@one.firstfloor.org>
References: <alpine.SOC.1.00.1106191927250.4844@math.ut.ee> <BANLkTiktb6GS7fcHRRgC=bHJjz8k0hVmPw@mail.gmail.com> <m2boxtfo0d.fsf@firstfloor.org> <20110619.160150.1199476848151993579.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110619.160150.1199476848151993579.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmmm, can this scheme actually work out properly on both big and
> little endian?  Because endianness determines whether the bits start
> in the "lower addressed" 32-bit word or the "higher addressed" 32-bit
> word.

True, it needs an ifdef, with the other order in BE. struct page has that iirc.

> 
> If this trick is being attempted elsewhere, I think it could perhaps
> account for some strange bugs :-)

Well if you want to be sure better try to get rid of the void *

(I tried early on in x86-64, it caused a lot of warnings all over)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
