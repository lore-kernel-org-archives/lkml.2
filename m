Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab1LAALe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:11:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1LAALd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:11:33 -0500
Date: Wed, 30 Nov 2011 16:11:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-Id: <20111130161131.31cdccff.akpm@linux-foundation.org>
In-Reply-To: <20111130152959.GA19205@sgi.com>
References: <20111108191149.GA7236@sgi.com>
	<20111122160802.e99d6218.akpm@linux-foundation.org>
	<20111130152959.GA19205@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011 09:29:59 -0600
Dimitri Sivanich <sivanich@sgi.com> wrote:

> +static ssize_t sysfs_store_do_timer_cpu(struct sys_device *dev,
> +						struct sysdev_attribute *attr,
> +						const char *buf, size_t size)
> +{
> +	struct sysdev_ext_attribute *ea = SYSDEV_TO_EXT_ATTR(attr);
> +	unsigned int new;
> +	int rv;
> +
> +#ifdef CONFIG_NO_HZ
> +	/* nohz mode not supported */
> +	if (tick_nohz_enabled)
> +		return -EINVAL;
> +#endif
> +
> +	rv = kstrtouint(buf, 0, &new);
> +	if (rv)
> +		return rv;
> +
> +	if (new >= NR_CPUS || !cpu_online(new))
> +		return -ERANGE;
> +
> +	*(unsigned int *)(ea->var) = new;
> +	return size;
> +}

checkpatch tells us:

WARNING: usage of NR_CPUS is often wrong - consider using cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc

I think the check can just be removed?  Surely cpu_online(1000000000)
will return false?

