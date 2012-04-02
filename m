Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2DBOzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:55:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64454 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2DBOzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:55:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hugh Dickins <hughd@google.com>
Subject: Re: swap on eMMC and other flash
Date: Mon, 2 Apr 2012 14:55:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linaro-kernel@lists.linaro.org, Rik van Riel <riel@redhat.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Alex Lemberg <alex.lemberg@sandisk.com>, linux-kernel@vger.kernel.org,
        "Luca Porzio (lporzio)" <lporzio@micron.com>, linux-mm@kvack.org,
        Hyojin Jeong <syr.jeong@samsung.com>, kernel-team@android.com,
        Yejin Moon <yejin.moon@samsung.com>
References: <201203301744.16762.arnd@arndb.de> <201204021145.43222.arnd@arndb.de> <alpine.LSU.2.00.1204020734560.1847@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1204020734560.1847@eggly.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204021455.25029.arnd@arndb.de>
X-Provags-ID: V02:K0:nZMFbmJdwz3oJmxVM0tRY4WtxDlpjoEw1hBgPLa+K6Y
 +bUdUpnZyGKYu9huzqDQqe9Sl9HTJSAb+OGb2Xz0G+CEbVsikK
 ChdCilmjVmm4J+v2jeJ8rPEPFXQyuIyRm551RH0FI/8AL1gAOB
 79dl87BOBWqZj7c+VtQFXoSHCNPtL5i4xIl8dVh7suyzR4Jj7D
 p/E5FRpWh0ddD6V3x8ch80LnTZmfiIOhCwvT/hMktcbk4msUpo
 zaow6AViJ2tANgl2YSUuoJRXHzjoL/9N+In0eb+I+BcirP+uej
 Jt5VXNVvgZeYcFB219ZMZ7tZFuwRJN5KcO6PrMfTYgfKvXv8PQ
 f2VQcGOPmVmPhN3zK9/E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2012, Hugh Dickins wrote:
> On Mon, 2 Apr 2012, Arnd Bergmann wrote:
> > 
> > Another option would be batched discard as we do it for file systems:
> > occasionally stop writing to swap space and scanning for areas that
> > have become available since the last discard, then send discard
> > commands for those.
> 
> I'm not sure whether you've missed "swapon --discard", which switches
> on discard_swap_cluster() just before we allocate from a new cluster;
> or whether you're musing that it's no use to you because you want to
> repurpose the swap cluster to match erase block: I'm mentioning it in
> case you missed that it's already there (but few use it, since even
> done at that scale it's often more trouble than it's worth).

I actually argued that discard_swap_cluster is exactly the right thing
to do, especially when clusters match erase blocks on the less capable
devices like SD cards.

Luca was arguing that on some hardware there is no point in ever
submitting a discard just before we start reusing space, because
at that point it the hardware already discards the old data by
overwriting the logical addresses with new blocks, while
issuing a discard on all blocks as soon as they become available
would make a bigger difference. I would be interested in hearing
from Hyojin Jeong and Alex Lemberg what they think is the best
time to issue a discard, because they would know about other hardware
than Luca.

	Arnd
