Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0H0Bly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 21:41:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45182 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab0H0Blt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 21:41:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JecGj29u0DpUYAVrAOa2Ew0A8aPnOxB+t7KyajDqjVGVroFi4+8yvUCTxFpwiGcvXU
         XOMZDLOiVo+kqQrjZTk5WgYJL/s+2IV8p3PFfJCrsGBk8GXASwG6ECwprxILcEhIisnh
         dTDZ76myukn5iA0PSyj5pi6aLLQBMGCx9B9RE=
MIME-Version: 1.0
In-Reply-To: <20100827012147.GC7353@localhost>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
	<20100826172038.GA6873@barrios-desktop>
	<20100827012147.GC7353@localhost>
Date: Fri, 27 Aug 2010 10:41:48 +0900
Message-ID: <AANLkTimLhZcP=eqB9TFfO_rgb-dhXUJh8iNTXuceuCq0@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Do not wait the full timeout on congestion_wait
 when there is no congestion
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Li Shaohua <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Wu.

On Fri, Aug 27, 2010 at 10:21 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> Minchan,
>
> It's much cleaner to keep the unchanged congestion_wait() and add a
> congestion_wait_check() for converting problematic wait sites. The
> too_many_isolated() wait is merely a protective mechanism, I won't
> bother to improve it at the cost of more code.

You means following as?

        while (unlikely(too_many_isolated(zone, file, sc))) {
                congestion_wait_check(BLK_RW_ASYNC, HZ/10);

                /* We are about to die and free our memory. Return now. */
                if (fatal_signal_pending(current))
                        return SWAP_CLUSTER_MAX;
        }


>
> Thanks,
> Fengguang
>

-- 
Kind regards,
Minchan Kim
