Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0LRATO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 19:19:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948Ab0LRATL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 19:19:11 -0500
Date: Fri, 17 Dec 2010 16:18:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCHv6 16/16] pps: add parallel port PPS signal generator
Message-Id: <20101217161837.5f083e73.akpm@linux-foundation.org>
In-Reply-To: <c297ae1ac0479685b45191c950317a0cc3406822.1292604060.git.lasaine@lvk.cs.msu.su>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
	<c297ae1ac0479685b45191c950317a0cc3406822.1292604060.git.lasaine@lvk.cs.msu.su>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010 22:54:40 +0300
Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> +static enum hrtimer_restart hrtimer_event(struct hrtimer *timer)
> +{
> +	struct timespec expire_time, ts1, ts2, ts3, dts;
> +	struct pps_generator_pp *dev;
> +	struct parport *port;
> +	long lim, delta;
> +	unsigned long flags;
> +
> +	/* NB: approx time with blocked interrupts =
> +	   send_delay + 3 * SAFETY_INTERVAL */
> +	local_irq_save(flags);

ditto.
