Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2A3Lxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 06:53:43 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60821 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab2A3Lxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 06:53:42 -0500
MIME-Version: 1.0
In-Reply-To: <20120130070635.412104517@sli10-conroe.sh.intel.com>
References: <20120130070213.793690895@sli10-conroe.sh.intel.com>
	<20120130070635.412104517@sli10-conroe.sh.intel.com>
Date: Mon, 30 Jan 2012 19:53:41 +0800
Message-ID: <CAJd=RBC7YCFN3T98en5dBo9T0Jar9cU+=dFtTK96VQuqQtGfgw@mail.gmail.com>
Subject: Re: [patch v2 8/8]block: fiops sync preempts async
From: Hillf Danton <dhillf@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        david@fromorbit.com, jack@suse.cz, zhu.yanhai@gmail.com,
        namhyung.kim@lge.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0UBrncp002057

Hello Shaohua

On Mon, Jan 30, 2012 at 3:02 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> Debug patch only.
>
> This implements CFQ like sync preempts async. But like CFQ, this
> will starve async.
>
> ---
> Â block/fiops-iosched.c | Â  15 +++++++++++++++
> Â 1 file changed, 15 insertions(+)
>
> Index: linux/block/fiops-iosched.c
> ===================================================================
> --- linux.orig/block/fiops-iosched.c Â  Â 2012-01-21 10:35:04.000000000 +0800
> +++ linux/block/fiops-iosched.c 2012-01-21 10:48:52.000000000 +0800
> @@ -408,6 +408,21 @@ static struct fiops_ioc *fiops_select_io
> Â  Â  Â  Â  Â  Â  Â  Â return NULL;
> Â  Â  Â  Â }
>
> + Â  Â  Â  /* Let sync request preempt async queue */
> + Â  Â  Â  if (!rq_is_sync(rq) && service_tree->count > 1) {
> + Â  Â  Â  Â  Â  Â  Â  struct rb_node *tmp = rb_next(&ioc->rb_node);
> + Â  Â  Â  Â  Â  Â  Â  struct fiops_ioc *sync_ioc = NULL;
> + Â  Â  Â  Â  Â  Â  Â  while (tmp) {
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  sync_ioc = rb_entry(tmp, struct fiops_ioc, rb_node);
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  rq = rq_entry_fifo(sync_ioc->fifo.next);
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  if (rq_is_sync(rq))
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  break;
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  tmp = rb_next(&sync_ioc->rb_node);

			sync_ioc = NULL;        yes?
Hillf
> + Â  Â  Â  Â  Â  Â  Â  }
> + Â  Â  Â  Â  Â  Â  Â  if (sync_ioc)
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  ioc = sync_ioc;
> + Â  Â  Â  }
> +
> Â  Â  Â  Â return ioc;
> Â }
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
