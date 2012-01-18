Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab2ARPaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:30:18 -0500
Received: from mail.servus.at ([193.170.194.20]:47398 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757910Ab2ARPaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:30:16 -0500
X-Greylist: delayed 1488 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jan 2012 10:30:16 EST
Message-ID: <4F16DFB0.2060404@oberhumer.com>
Date: Wed, 18 Jan 2012 16:05:20 +0100
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>
Subject: Re: Updated btrfs/crypto snappy interface ready for merging
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
X-no-Archive: yes
X-Oberhumer-Conspiracy: There is no conspiracy. Trust us.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-13 01:28, Andi Kleen wrote:
> Here's a slightly updated version of the BTRFS snappy interface.
> snappy is a faster compression algorithm that provides similar
> compression as LZO, but generally better performance.

I'd like to note that the LZO version in the current Linux kernel is
rather outdated - it seems to be based on the 2005 release.

In fact the latest version LZO 2.06 does compress both slightly faster and
better than snappy 1.0.4 when benchmarking the Calgary and Silesia
compression corpus (tested with gcc 4.6 on Nehalem & Sandy Bridge).

Furthermore please be aware that from a pure compression point of view
snappy et al. are very close cousins of LZO (strictly byte-aligned LZ77)
that mainly differ in implementation issues like using a table to
number of branches - and indeed similar optimizations could be applied
to any version.

I'm not sure if there is an official kernel maintainer of LZO, but I'd
offer to assist you updating to the latest version and eliminating
any possible performance issues.

Cheers,
Markus

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
