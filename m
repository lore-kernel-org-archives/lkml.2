Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2LJUIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 15:08:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57564 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2LJUIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 15:08:45 -0500
Date: Mon, 10 Dec 2012 12:05:12 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Glauber Costa <glommer@parallels.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>, John Stultz <john.stultz@linaro.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com
Subject: Re: [RFC v2] Add mempressure cgroup
Message-ID: <20121210200512.GA499@lizard>
References: <20121210095838.GA21065@lizard>
 <201212101323.09806.b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201212101323.09806.b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 01:23:09PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Monday 10 December 2012 10:58:38 Anton Vorontsov wrote:
> 
> > +static void consume_memory(void)
> > +{
> > +	unsigned int i = 0;
> > +	unsigned int j = 0;
> > +
> > +	puts("consuming memory...");
> > +
> > +	while (1) {
> > +		pthread_mutex_lock(&locks[i]);
> > +		if (!chunks[i]) {
> > +			chunks[i] = malloc(CHUNK_SIZE);
> > +			pabort(!chunks[i], 0, "chunks alloc failed");
> > +			memset(chunks[i], 0, CHUNK_SIZE);
> > +			j++;
> > +		}
> > +		pthread_mutex_unlock(&locks[i]);
> > +
> > +		if (j >= num_chunks / 10) {
> > +			add_reclaimable(num_chunks / 10);
> 
> Shouldn't it use j instead of num_chunks / 10 here?

Um.. They should be equal. Or am I missing the point?

> > +			printf("added %d reclaimable chunks\n", j);
> > +			j = 0;

Here, we reset it.

> > +		}
> > +
> > +		i = (i + 1) % num_chunks;
> > +	}
> > +}

Thanks!
Anton.
