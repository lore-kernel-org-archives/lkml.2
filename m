Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab1HWJPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:15:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41778
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128Ab1HWJPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:15:30 -0400
Date: Tue, 23 Aug 2011 05:15:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, khlebnikov@openvz.org
Subject: Re: [PATCH 04/13] mm: new shrinker API
Message-ID: <20110823091529.GC21492@infradead.org>
References: <1314089786-20535-1-git-send-email-david@fromorbit.com>
 <1314089786-20535-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314089786-20535-5-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /*
>   * A callback you can register to apply pressure to ageable caches.

It's much more than just a single callback these days.

> + * @scan_objects will be made from the current reclaim context.
>   */
>  struct shrinker {
>  	int (*shrink)(struct shrinker *, struct shrink_control *sc);
> +	long (*count_objects)(struct shrinker *, struct shrink_control *sc);
> +	long (*scan_objects)(struct shrinker *, struct shrink_control *sc);

Is shrink_object really such a good name for this method?

