Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576Ab0HENzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 09:55:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48572 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab0HENzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 09:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TZdFVPGPoIkIcQsZqVrpG5npNrfRCgwj9lQq1ALtMhRLCIN0aNMYsq7GSmUROt7Gra
         o5WCNfvJZNYO2VAsp/YxZoAwxCSgPpsnxI91ro3kP69wEA7iZKugz8uvSG029oZWUFuc
         eLYeQ9dZAogQKirbG14WmJKl1HpsE1pUCYA90=
Date: Thu, 5 Aug 2010 22:55:04 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/7] vmscan: synchronous lumpy reclaim don't call
 congestion_wait()
Message-ID: <20100805135504.GA2985@barrios-desktop>
References: <20100805150624.31B7.A69D9226@jp.fujitsu.com>
 <20100805151229.31BD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805151229.31BD.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 03:13:03PM +0900, KOSAKI Motohiro wrote:
> congestion_wait() mean "waiting quueue congestion is cleared".
> That said, if the system have plenty dirty pages and flusher thread push
> new request to IO queue conteniously, IO queue are not cleared
> congestion status for long time. thus, congestion_wait(HZ/10) become
> almostly equivalent schedule_timeout(HZ/10).
> 
> However, synchronous lumpy reclaim donesn't need this
> congestion_wait() at all. shrink_page_list(PAGEOUT_IO_SYNC) are
> using wait_on_page_writeback() and it provide sufficient waiting.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
