Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab1DXCBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 22:01:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43703 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab1DXCBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 22:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hLilDHGpPTqg52mB70mU3kYL7X086Mk3oEarNQgkf5Vwtrcin0knjrglJc9CQv8G7O
         /TaffSNbipf4WLE7tIZbPJuF1PfDHZR+S/GtPzgBJsv9Mg5KJsPRAlr9hOQFFcDn7Kd5
         3fbxq3fsEq40m52kbiRbny5WojPBnNEbc7eec=
Date: Sun, 24 Apr 2011 11:01:22 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH] Check PageActive when evictable page and unevicetable
 page race happen
Message-ID: <20110424020122.GA6228@barrios-desktop>
References: <1303604751-4980-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303604751-4980-1-git-send-email-minchan.kim@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 24, 2011 at 09:25:51AM +0900, Minchan Kim wrote:
> In putback_lru_page, unevictable page can be changed into evictable
> 's one while we move it among lru. So we have checked it again and
> rescued it. But we don't check PageActive, again. It could add
> active page into inactive list so we can see the BUG in isolate_lru_pages.
> (But I didn't see any report because I think it's very subtle)

As I look the code further, that's because lru_cache_add_lru always 
cleans up PageActive regardless of LRU list. 
If active page goes to inactive list, we shouldn't meet the BUG 
but it's apparently wrong. 

-- 
Kind regards,
Minchan Kim
