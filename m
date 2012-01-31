Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2AaUgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 15:36:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab2AaUgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 15:36:13 -0500
Date: Tue, 31 Jan 2012 12:36:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] speed up /proc/pid/stat, statm
Message-Id: <20120131123612.6b60bdfc.akpm@linux-foundation.org>
In-Reply-To: <20120131171443.567b53ad.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120131171443.567b53ad.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 17:14:43 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> +int seq_put_decimal_ll(struct seq_file *m, char delimiter,
> +			long long num)
> +{
> +	if (num < 0) {
> +		if (m->count + 3 >= m->size) {
> +			m->count = m->size;

Why is m->count udpated even thought we didn't write any data? 
seq_put_decimal_ull() does it too.

> +			return -1;
> +		}
> +		if (delimiter)
> +			m->buf[m->count++] = delimiter;
> +		num = -num;
> +		delimiter = '-';
> +	}
> +	return seq_put_decimal_ull(m, delimiter, num);
> +
> +}
> +EXPORT_SYMBOL(seq_put_decimal_ll);
