Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0GRI1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 04:27:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59442 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0GRI12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 04:27:28 -0400
Message-ID: <4C42BAE5.9020606@cs.helsinki.fi>
Date: Sun, 18 Jul 2010 11:27:17 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Nitin Gupta <ngupta@vflare.org>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] Basic zcache functionality
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org> <1279283870-18549-3-git-send-email-ngupta@vflare.org>
In-Reply-To: <1279283870-18549-3-git-send-email-ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nitin Gupta wrote:
> +static void zcache_add_stat(struct zcache_pool *zpool,
> +		enum zcache_pool_stats_index idx, s64 val)
> +{
> +	struct zcache_pool_stats_cpu *stats;
> +
> +	preempt_disable();
> +	stats = __this_cpu_ptr(zpool->stats);
> +	u64_stats_update_begin(&stats->syncp);
> +	stats->count[idx] += val;
> +	u64_stats_update_end(&stats->syncp);
> +	preempt_enable();
> +
> +}

You should probably use this_cpu_inc() here.
