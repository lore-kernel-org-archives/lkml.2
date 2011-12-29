Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1L2Tb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 14:31:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab1L2Tb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 14:31:57 -0500
Message-ID: <4EFCC008.30803@redhat.com>
Date: Thu, 29 Dec 2011 14:31:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/11] mm: Isolate pages for immediate reclaim on their
 own LRU
References: <1323877293-15401-1-git-send-email-mgorman@suse.de> <1323877293-15401-12-git-send-email-mgorman@suse.de> <20111217160822.GA10064@barrios-laptop.redhat.com> <20111219132615.GL3487@suse.de> <20111220071026.GA19025@barrios-laptop.redhat.com> <20111220095544.GP3487@suse.de> <alpine.LSU.2.00.1112231039030.17640@eggly.anvils> <20111229165951.GA15729@suse.de>
In-Reply-To: <20111229165951.GA15729@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2011 11:59 AM, Mel Gorman wrote:

> I considered a few ways of fixing this. The obvious one is to add a
> new page flag but that is difficult to justify as the high-cpu-usage
> problem should only occur when there is a lot of writeback to slow
> storage which I believe is a rare case. It is not a suitable use for
> an extended page flag.

Actually, don't we already have three LRU related
bits in the page flags?

We could stop using those as bit flags, and use
them as a number instead. That way we could encode
up to 7 or 8 (depending on how we use all-zeroes)
LRU lists with the number of bits we have now.

-- 
All rights reversed
