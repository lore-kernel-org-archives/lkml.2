Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab1F3WlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:41:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38560 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1F3WlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:41:14 -0400
Date: Fri, 1 Jul 2011 01:40:19 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Marcus Klemm <marcus.klemm@googlemail.com>, kvm@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@linuxdriverproject.org
Subject: Re: [PATCH v2] staging: zcache: support multiple clients, prep for
 KVM and RAMster
Message-ID: <20110630224019.GC2544@shale.localdomain>
References: <1d15f28a-56df-4cf4-9dd9-1032f211c0d0@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d15f28a-56df-4cf4-9dd9-1032f211c0d0@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 12:01:08PM -0700, Dan Magenheimer wrote:
> +static int zv_curr_dist_counts_show(char *buf)
> +{
> +	unsigned long i, n, chunks = 0, sum_total_chunks = 0;
> +	char *p = buf;
> +
> +	for (i = 0; i <= NCHUNKS - 1; i++) {

It's more common to write the condition as:  i < NCHUNKS.


> +		n = zv_curr_dist_counts[i];

zv_curr_dist_counts has NCHUNKS + 1 elements so we never print
display the final element.  I don't know this coe, so I could be
wrong but I think that we could make zv_curr_dist_counts only hold
NCHUNKS elements.

> +		p += sprintf(p, "%lu ", n);
> +		chunks += n;
> +		sum_total_chunks += i * n;
> +	}
> +	p += sprintf(p, "mean:%lu\n",
> +		chunks == 0 ? 0 : sum_total_chunks / chunks);
> +	return p - buf;
> +}
> +
> +static int zv_cumul_dist_counts_show(char *buf)
> +{
> +	unsigned long i, n, chunks = 0, sum_total_chunks = 0;
> +	char *p = buf;
> +
> +	for (i = 0; i <= NCHUNKS - 1; i++) {
> +		n = zv_cumul_dist_counts[i];

Same situation.

> +		p += sprintf(p, "%lu ", n);
> +		chunks += n;
> +		sum_total_chunks += i * n;
> +	}
> +	p += sprintf(p, "mean:%lu\n",
> +		chunks == 0 ? 0 : sum_total_chunks / chunks);
> +	return p - buf;
> +}
> +

regards,
dan carpenter
