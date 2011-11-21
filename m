Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab1KUV77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:59:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab1KUV76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:59:58 -0500
Message-ID: <4ECAC9C8.5040202@redhat.com>
Date: Mon, 21 Nov 2011 16:59:36 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] mm: compaction: avoid overwork in migrate sync mode
References: <1321635524-8586-1-git-send-email-mgorman@suse.de> <1321732460-14155-6-git-send-email-aarcange@redhat.com>
In-Reply-To: <1321732460-14155-6-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2011 02:54 PM, Andrea Arcangeli wrote:
> Add a lightweight sync migration (sync == 2) mode that avoids overwork
> so more suitable to be used by compaction to provide lower latency but

> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -552,7 +552,7 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
>   		nr_migrate = cc->nr_migratepages;
>   		err = migrate_pages(&cc->migratepages, compaction_alloc,
>   				(unsigned long)cc, false,
> -				cc->sync);
> +				cc->sync ? 2 : 0);

Great idea, but it would be good if these numbers got
a symbolic name so people trying to learn the code can
figure it out a little easier.

