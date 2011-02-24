Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab1BXKHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 05:07:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab1BXKHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 05:07:01 -0500
Message-ID: <4D662DBF.2020706@redhat.com>
Date: Thu, 24 Feb 2011 12:06:55 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        xiaoguangrong@cn.fujitsu.com
Subject: Re: [RFC PATCH 0/3] Weight-balanced binary tree + KVM growable memory
 slots using wbtree
References: <1298386481.5764.60.camel@x201>	 <20110222183822.22026.62832.stgit@s20.home>  <4D6507C9.1000906@redhat.com>	 <1298484395.18387.28.camel@x201> <1298489332.18387.56.camel@x201>
In-Reply-To: <1298489332.18387.56.camel@x201>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 09:28 PM, Alex Williamson wrote:
> I had forgotten about<1M mem, so actually the slot configuration was:
>
> 0:<1M
> 1: 1M - 3.5G
> 2: 4G+
>
> I stacked the deck in favor of the static array (0: 4G+, 1: 1M-3.5G, 2:
> <1M), and got these kernbench results:
>
>              base (stdev)    reorder (stdev)   wbtree (stdev)
> --------+-----------------+----------------+----------------+
> Elapsed |  42.809 (0.19)  |  42.160 (0.22) |  42.305 (0.23) |
> User    | 115.709 (0.22)  | 114.358 (0.40) | 114.720 (0.31) |
> System  |  41.605 (0.14)  |  40.741 (0.22) |  40.924 (0.20) |
> %cpu    |   366.9 (1.45)  |   367.4 (1.17) |   367.6 (1.51) |
> context |  7272.3 (68.6)  |  7248.1 (89.7) |  7249.5 (97.8) |
> sleeps  | 14826.2 (110.6) | 14780.7 (86.9) | 14798.5 (63.0) |
>
> So, wbtree is only slightly behind reordering, and the standard
> deviation suggests the runs are mostly within the noise of each other.
> Thanks,

Doesn't this indicate we should use reordering, instead of a new data 
structure?

-- 
error compiling committee.c: too many arguments to function

