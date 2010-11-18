Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037Ab0KRO2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:28:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757377Ab0KRO2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:28:12 -0500
Message-ID: <4CE537BE.6090103@redhat.com>
Date: Thu, 18 Nov 2010 09:27:10 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Li, Shaohua" <shaohua.li@intel.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] writeback: prevent bandwidth calculation overflow
References: <20101118065725.GB8458@localhost>
In-Reply-To: <20101118065725.GB8458@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 01:57 AM, Wu Fengguang wrote:
> On 32bit kernel, bdi->write_bandwidth can express at most 4GB/s.
>
> However the current calculation code can overflow when disk bandwidth
> reaches 800MB/s.  Fix it by using "long long" and swapping the order of
> multiplication/division. And further, change its unit to pages/second
> rather than bytes/second. That allows up to 16TB/s bandwidth in 32bit
> kernel.
>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
