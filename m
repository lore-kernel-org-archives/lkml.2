Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2LKNXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:23:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:46771 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2LKNXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:23:18 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-0b-50c733c41c03
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [RFC v2] Add mempressure cgroup
Date: Tue, 11 Dec 2012 14:22:38 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
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
References: <20121210095838.GA21065@lizard>
 <201212101323.09806.b.zolnierkie@samsung.com> <20121210200512.GA499@lizard>
In-reply-to: <20121210200512.GA499@lizard>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201212111422.38970.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jAd2jxscDDHY+Yba4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZP95yFPzlrGh4Pp21gXERexcjJ4eEgInErd4HbBC2mMSFe+uB
	bC4OIYFFjBK9jc+ZIZylTBK3ft1hBaliE7CSmNi+ihHEFhEwkDj4cCkTiC0soCOxfMIUsBoW
	AVWJhk8LwDaICjhIdE6dADaVWaCLVeLzv9tg64QEKiWurdgA1sApoCUxt6OTBcTmFRCU+DH5
	HpjNDBRvfrOJEcKWl9i85i0zRI2lxJRbExgnMArMQtIyC0nLLCQtCxiZVzGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIEh+AzqR2MKxssDjEKcDAq8fBqaB0LEGJNLCuuzD3EKMHBrCTCGyl0
	PECINyWxsiq1KD++qDQntfgQozQHi5I4b7NHSoCQQHpiSWp2ampBahFMlomDU6qBceUvnoo3
	u5P3Nq3U7K7N1OTROJ5X+MNdzWPdWT8Z6SVsj0/22QQI80ave7ya38pd6Lqi2P+UyybbOf3c
	8h/8/ffU6+0HqYcL0r9tSp9c2//3CF/Z49xzq9uEbPZaKzO8mmknYrnT9vI2pbecN97p737N
	YVUQ2jxp0Zst2okWPXI3z99bd+K1gBJLcUaioRZzUXEiAKffB5E9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2012 21:05:12 Anton Vorontsov wrote:
> On Mon, Dec 10, 2012 at 01:23:09PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Monday 10 December 2012 10:58:38 Anton Vorontsov wrote:
> > 
> > > +static void consume_memory(void)
> > > +{
> > > +	unsigned int i = 0;
> > > +	unsigned int j = 0;
> > > +
> > > +	puts("consuming memory...");
> > > +
> > > +	while (1) {
> > > +		pthread_mutex_lock(&locks[i]);
> > > +		if (!chunks[i]) {
> > > +			chunks[i] = malloc(CHUNK_SIZE);
> > > +			pabort(!chunks[i], 0, "chunks alloc failed");
> > > +			memset(chunks[i], 0, CHUNK_SIZE);
> > > +			j++;
> > > +		}
> > > +		pthread_mutex_unlock(&locks[i]);
> > > +
> > > +		if (j >= num_chunks / 10) {
> > > +			add_reclaimable(num_chunks / 10);
> > 
> > Shouldn't it use j instead of num_chunks / 10 here?
> 
> Um.. They should be equal. Or am I missing the point?

Oh, ok.  You're right.

j > num_chunks / 10 condition should never happen and may be removed.

> > > +			printf("added %d reclaimable chunks\n", j);
> > > +			j = 0;
> 
> Here, we reset it.
> 
> > > +		}
> > > +
> > > +		i = (i + 1) % num_chunks;
> > > +	}
> > > +}
> 
> Thanks!
> Anton.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
