Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965568Ab2EQQfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:35:08 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:37020 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255Ab2EQQfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:35:05 -0400
Message-ID: <4FB528B3.8000406@parallels.com>
Date: Thu, 17 May 2012 20:34:59 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [rfc 3/4] fs, eventfd: Add procfs fdinfo helper
References: <20120517160738.116113099@openvz.org> <20120517162534.755208902@openvz.org>
In-Reply-To: <20120517162534.755208902@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void *seq_start(struct seq_file *m, loff_t *pos)
> +{
> +	struct proc_fdinfo_extra *extra = m->private;
> +	return *pos == 1 ? extra->fd_file : NULL;
> +}
> +
> +static void seq_stop(struct seq_file *m, void *v)
> +{
> +}
> +
> +static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
> +{
> +	struct proc_fdinfo_extra *extra = m->private;
> +	return ++*pos == 1 ? extra->fd_file : NULL;
> +}
> +

<snip>

> +static const struct seq_operations eventfd_fdinfo_ops = {
> +	.start	= seq_start,
> +	.next	= seq_next,
> +	.stop	= seq_stop,
> +	.show	= seq_show,

I think, you can use the single_ part of the seq files engine.

> +};

Thanks,
Pavel
