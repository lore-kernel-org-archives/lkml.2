Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0LJDxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:53:41 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:48419 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0LJDxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:53:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U+Q1q6Irmmih5wDt0QurMe7m1nv+gpIxlW95VOJQjP+YcERIWyXrCJZidQ2cXkk579
         WxRpL8ZTsy0jgZn+UfKxlnZiGDvbFT+B4BoKoZ3IKR2AvomYZNX6u4lqdsxrXDQM6AIT
         fAOa38oTYd2GT46bMhurnWMhwDI/vWq1ouKVA=
MIME-Version: 1.0
In-Reply-To: <20101209141317.60d14fb5.akpm@linux-foundation.org>
References: <1291305649-2405-1-git-send-email-minchan.kim@gmail.com>
	<20101209141317.60d14fb5.akpm@linux-foundation.org>
Date: Fri, 10 Dec 2010 12:53:39 +0900
Message-ID: <AANLkTikxRpiRdXpxgAJWaOhhA32Fup97DLYA9gNUS5TP@mail.gmail.com>
Subject: Re: [PATCH] vmscan: make kswapd use a correct order
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 7:13 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri,  3 Dec 2010 01:00:49 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> +static bool kswapd_try_to_sleep(pg_data_t *pgdat, int order)
>
> OT: kswapd_try_to_sleep() does a
> trace_mm_vmscan_kswapd_sleep(pgdat->node_id) if it sleeps for a long
> time, but doesn't trace anything at all if it does a short sleep.
> Where's the sense in that?
>

AFAIU, short sleep is _sleep_ but that trace's goal is to count only long sleep.
In addition, short sleep is a just ready to go or not long sleep so I
think we don't need short sleep trace.
And for knowing short sleep count, we can use
KSWAPD_{LOW|HIGH}_WMARK_HIT_QUICKLY.

-- 
Kind regards,
Minchan Kim
