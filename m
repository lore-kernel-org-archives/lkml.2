Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab2DJIrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:47:47 -0400
Received: from smtp3.su.se ([130.237.164.77]:44112 "EHLO smtp.su.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753478Ab2DJIrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:47:45 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2012 04:47:45 EDT
X-Spam-Flag: NO
X-Spam-Score: -4
Message-ID: <4F83F202.2080600@debian.org>
Date: Tue, 10 Apr 2012 10:40:34 +0200
From: Per Olofsson <pelle@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9]: Hibernation: fix the number of pages used for hibernate/thaw
 buffering
References: <1334026047.2103.23.camel@shrek.rexursive.com>
In-Reply-To: <1334026047.2103.23.camel@shrek.rexursive.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-10 04:47, Bojan Smojver wrote:
> +/*
> + * Number of free pages that are not high.
> + */
> +static unsigned long low_free_pages(void)
> +{
> +	struct zone *zone;
> +	unsigned long free = 0;
> +
> +	for_each_populated_zone(zone)
> +		if (!is_highmem(zone))
> +			free += zone_page_state(zone, NR_FREE_PAGES);
> +	return free;
> +}

Nitpick: it should be faster to calculate "nr_free_pages() -
nr_free_highpages()", at least on systems without high pages. But
perhaps it does not matter.

-- 
Pelle
