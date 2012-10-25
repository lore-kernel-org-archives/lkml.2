Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422687Ab2JYJ0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:26:07 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38545 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934971Ab2JYJ0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:26:03 -0400
Date: Thu, 25 Oct 2012 02:23:05 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC v2 0/2] vmevent: A bit reworked pressure attribute + docs +
 man page
Message-ID: <20121025092305.GA32417@lizard>
References: <20121022111928.GA12396@lizard>
 <20121025064009.GA15767@bbox>
 <20121025090813.GA16078@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121025090813.GA16078@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:08:14AM -0700, Anton Vorontsov wrote:
[...]
> Maybe it makes sense to implement something like PRESSURE_MILD with an
> additional nr_pages threshold, which basically hits the kernel about how
> many easily reclaimable pages userland has (that would be a part of our
> definition for the mild pressure level). So, essentially it will be
> 
> 	if (pressure_index >= oom_level)
> 		return PRESSURE_OOM;
> 	else if (pressure_index >= med_level)
> 		return PRESSURE_MEDIUM;
> 	else if (userland_reclaimable_pages >= nr_reclaimable_pages)
> 		return PRESSURE_MILD;

...or we can call it PRESSURE_BALANCE, just to be precise and clear.
