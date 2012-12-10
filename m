Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2LJMYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 07:24:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15035 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2LJMYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 07:24:43 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-cd-50c5d489a295
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [RFC v2] Add mempressure cgroup
Date: Mon, 10 Dec 2012 13:23:09 +0100
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
In-reply-to: <20121210095838.GA21065@lizard>
MIME-version: 1.0
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201212101323.09806.b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jQd2uK0cDDCYeYLa4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZM5/vZC1YwlaxfO4r1gbGmyxdjJwcEgImEjs/tkLZYhIX7q1n
	62Lk4hASmM4ocfn2QnYIZymTRN+vNUwgVWwCVhIT21cxgtgiAgYSBx8uBYsLC+hILJ8whRXE
	ZhFQlTi3sgnMFhVwkOicOgFsKrNAF6vE53+3gRwOoKnaEieO1oLUcAL19h7eyw5i8woISvyY
	fA/sImYBLYnmN5sYIWx5ic1r3jJD1FhKnGh8yTaBUWAWkpZZSFpmIWlZwMi8ilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4BJ9J7WBc2WBxiFGAg1GJhzdA8WiAEGtiWXFl7iFGCQ5mJRFe
	sZNAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzNHikBQgLpiSWp2ampBalFMFkmDk6pBsYlG4qT
	lvHqpgXb758xf7WPqJ1tWptLVITxe5YOvTtrv88xeXue/bX0Kz7+M2HMJzhb30m0Vx5j/vOy
	pF1E1sS56To3o53l90/P21svH2ZZonV3/9rpM050XqyfIWJb6sjZzMsxX8Bq7XYWU9GNQt7v
	lvrLW+g1zi3757GO9QGPTfX07pPha5VYijMSDbWYi4oTAdRu44U9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2012 10:58:38 Anton Vorontsov wrote:

> +static void consume_memory(void)
> +{
> +	unsigned int i = 0;
> +	unsigned int j = 0;
> +
> +	puts("consuming memory...");
> +
> +	while (1) {
> +		pthread_mutex_lock(&locks[i]);
> +		if (!chunks[i]) {
> +			chunks[i] = malloc(CHUNK_SIZE);
> +			pabort(!chunks[i], 0, "chunks alloc failed");
> +			memset(chunks[i], 0, CHUNK_SIZE);
> +			j++;
> +		}
> +		pthread_mutex_unlock(&locks[i]);
> +
> +		if (j >= num_chunks / 10) {
> +			add_reclaimable(num_chunks / 10);

Shouldn't it use j instead of num_chunks / 10 here?

> +			printf("added %d reclaimable chunks\n", j);
> +			j = 0;
> +		}
> +
> +		i = (i + 1) % num_chunks;
> +	}
> +}

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
