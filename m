Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab0FVPbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:31:48 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52008 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab0FVPbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 11:31:46 -0400
Date: Tue, 22 Jun 2010 18:36:33 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: "Doyu Hiroshi (Nokia-D/Helsinki)" <hiroshi.doyu@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/1] kmemleak: Fix false positive with alias
Message-ID: <20100622153633.GY17639@pcarmody-desktop>
References: <20100602.143458.232754971.Hiroshi.DOYU@nokia.com> <1276841055-13843-1-git-send-email-Hiroshi.DOYU@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276841055-13843-1-git-send-email-Hiroshi.DOYU@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 22 Jun 2010 15:31:35.0270 (UTC) FILETIME=[FFA85860:01CB121F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/10 08:04 +0200, Doyu Hiroshi (Nokia-D/Helsinki) wrote:
> Hi,
> 
> This is another version of "kmemleak: Fix false positive", which
> introduces another alias tree to keep track of all alias address of
> each objects, based on the discussion(*1)
> 
> You can also find the previous one(*2), which uses special scan area
> for alias addresses with a conversion function.
> 
> Compared with both methods, it seems that the current one takes a bit
> longer to scan as below, tested with 512 elementes of (*3).
> 
> "kmemleak: Fix false positive with alias":
> # time echo scan > /mnt/kmemleak
> real    0m 8.40s
> user    0m 0.00s
> sys     0m 8.40s
> 
> "kmemleak: Fix false positive with special scan":
> # time echo scan > /mnt/kmemleak 
> real    0m 3.96s
> user    0m 0.00s
> sys     0m 3.96s
> 
> For our case(*4) to reduce false positives for the 2nd level IOMMU
> pagetable allocation, the previous special scan  seems to be enough
> lightweight, although there might be possiblity to improve alias
> one and also I might misunderstand the original proposal of aliasing.
> 
> Any comment would be appreciated.

After comparing the two, my Ack would still strongly be behind the 
first one, the special scan. The additional work over a normal scan 
is limited strictly to those regions that need it, which is a much 
more clinical approach to the problem. Your timing data bears that 
out.

Phil

> *1: http://lkml.org/lkml/2010/6/2/282
> *2: kmemleak: Fix false positive with special scan
>     http://lkml.org/lkml/2010/6/1/137
> *3: kmemleak: Add special scan test case
>     http://lkml.org/lkml/2010/6/1/134
> *4: http://lkml.org/lkml/2010/6/1/136
> 
> Hiroshi DOYU (1):
>   kmemleak: Fix false positive with alias
> 
>  include/linux/kmemleak.h |    4 +
>  mm/kmemleak.c            |  198 ++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 168 insertions(+), 34 deletions(-)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
