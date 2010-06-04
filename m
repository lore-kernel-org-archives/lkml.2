Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab0FDBII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:08:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54400 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756856Ab0FDBIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:08:04 -0400
Message-ID: <4C085289.9040000@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 09:10:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/6] writeback: initial tracing support
References: <1275609328-12514-1-git-send-email-david@fromorbit.com> <1275609328-12514-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1275609328-12514-2-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +TRACE_EVENT(writeback_queue,
> +
> +	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_args *args),
> +
> +	TP_ARGS(bdi, args),
> +
> +	TP_STRUCT__entry(
> +		__array(char,		name,		16)
> +		__field(long,		nr_pages)
> +		__field(int,		sb)
> +		__field(int,		sync_mode)
> +		__field(int,		for_kupdate)
> +		__field(int,		range_cyclic)
> +		__field(int,		for_background)
> +	),
> +
> +	TP_fast_assign(
> +		strncpy(__entry->name, dev_name(bdi->dev), 16);

Should use strlcpy() ?

> +		__entry->nr_pages	= args->nr_pages;
> +		__entry->sb		= !!args->sb;
> +		__entry->for_kupdate	= args->for_kupdate;
> +		__entry->range_cyclic	= args->range_cyclic;
> +		__entry->for_background	= args->for_background;
> +	),
> +
> +	TP_printk("%s: pages=%ld, sb=%d, kupdate=%d, range_cyclic=%d "
> +		  "for_background=%d", __entry->name, __entry->nr_pages,
> +			__entry->sb, __entry->for_kupdate,
> +			__entry->range_cyclic, __entry->for_background)
> +);
> +
> +TRACE_EVENT(writeback_sched,
> +
> +	TP_PROTO(struct backing_dev_info *bdi, struct bdi_work *work,
> +		 const char *msg),
> +
> +	TP_ARGS(bdi, work, msg),
> +
> +	TP_STRUCT__entry(
> +		__array(char,			name,		16)
> +		__field(unsigned int,		work)
> +		__array(char,			task,		8)
> +	),
> +
> +	TP_fast_assign(
> +		strncpy(__entry->name, dev_name(bdi->dev), 16);

ditto

> +		__entry->work = (unsigned long) work & 0xffff;
> +		snprintf(__entry->task, 8, "%s", msg);
> +	),
> +
> +	TP_printk("work=%x, task=%s", __entry->work, __entry->task)
> +);

...

> +TRACE_EVENT(writeback_bdi_register,
> +
> +	TP_PROTO(const char *name, int start),
> +
> +	TP_ARGS(name, start),
> +
> +	TP_STRUCT__entry(
> +		__array(char,	name,		16)
> +		__field(int,	start)
> +	),
> +
> +	TP_fast_assign(
> +		strncpy(__entry->name, name, 16);

ditto

> +		__entry->start = start;
> +	),
> +
> +	TP_printk("%s: %s", __entry->name,
> +			__entry->start ? "registered" : "unregistered")
> +);
