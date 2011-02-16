Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1BPRNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:13:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab1BPRNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:13:10 -0500
Subject: Re: [PATCH] gpio: add trace events for setting direction and value
From: Steven Rostedt <srostedt@redhat.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        David Brownell <dbrownell@users.sourceforge.net>
In-Reply-To: <1297875784-2302-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1297875784-2302-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Wed, 16 Feb 2011 12:12:51 -0500
Message-ID: <1297876371.26768.7235.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 18:03 +0100, Uwe Kleine-König wrote:

> --- /dev/null
> +++ b/include/trace/events/gpio.h
> @@ -0,0 +1,56 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM gpio
> +
> +#if !defined(_TRACE_GPIO_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_GPIO_H
> +
> +#include <linux/tracepoint.h>
> +
> +TRACE_EVENT(gpio_direction,
> +
> +	TP_PROTO(unsigned gpio, int in, int err),
> +
> +	TP_ARGS(gpio, in, err),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned, gpio)
> +		__field(int, in)
> +		__field(int, err)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->gpio = gpio;
> +		__entry->in = in;
> +		__entry->err = err;
> +	),
> +
> +	TP_printk("%u %3s (%d)", __entry->gpio,
> +		__entry->in ? "in" : "out", __entry->err)
> +);
> +
> +TRACE_EVENT(gpio_value,
> +
> +	TP_PROTO(unsigned gpio, int get, int value),
> +
> +	TP_ARGS(gpio, get, value),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned, gpio)
> +		__field(int, get)
> +		__field(int, value)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->gpio = gpio;
> +		__entry->get = get;
> +		__entry->value = value;
> +	),
> +
> +	TP_printk("%u %3s %d", __entry->gpio,
> +		__entry->get ? "get" : "set", __entry->value)
> +);
> +

Note: to save the memory footprint of these tracepoints, you can use
DEFINE_EVENT_PRINT(). You can see the usage for this in the
include/trace/events/kmem.h.

But to do this, you will need to have a single TP_STRUCT__entry() for
both. Not sure if this is what you want.

	TP_STRUCT__entry(
		__field(unsigned, gpiq)
		__field(int, get_in)
		__field(int, value_err)

??

Just a suggestion, but may not be worth it.

-- Steve


