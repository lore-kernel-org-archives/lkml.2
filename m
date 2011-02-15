Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab1BOUBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 15:01:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755353Ab1BOUBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 15:01:23 -0500
Message-ID: <4D5ADB72.2050006@redhat.com>
Date: Tue, 15 Feb 2011 18:00:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andy Walls <awalls@md.metrocast.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        stoth@kernellabs.com
Subject: Re: [PATCH] cx23885: restore flushes of cx23885_dev work items
References: <1297647322.19186.61.camel@localhost> <20110214043355.GA28090@core.coreip.homeip.net> <20110214110339.GC18742@htj.dyndns.org> <1297731276.2394.19.camel@localhost> <20110215092012.GE3160@htj.dyndns.org>
In-Reply-To: <20110215092012.GE3160@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 15-02-2011 07:20, Tejun Heo escreveu:
> Commit 8c71778c (media/video: don't use flush_scheduled_work())
> dropped flush_scheduled_work() from cx23885_input_ir_stop()
> incorrectly assuming that it didn't use any work item; however,
> cx23885_dev makes use of three work items - cx25840_work and
> ir_{r|t}x_work.
> 
> Make cx23885_input_ir_stop() sync flush all three work items before
> returning.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Andy Walls <awalls@md.metrocast.net>
> Reviewed-by: Andy Walls <awalls@md.metrocast.net>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> ---
>  drivers/media/video/cx23885/cx23885-input.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
> index 199b996..e27cedb 100644
> --- a/drivers/media/video/cx23885/cx23885-input.c
> +++ b/drivers/media/video/cx23885/cx23885-input.c
> @@ -229,6 +229,9 @@ static void cx23885_input_ir_stop(struct cx23885_dev *dev)
>  		v4l2_subdev_call(dev->sd_ir, ir, rx_s_parameters, &params);
>  		v4l2_subdev_call(dev->sd_ir, ir, rx_g_parameters, &params);
>  	}
> +	flush_work_sync(&dev->cx25840_work);
> +	flush_work_sync(&dev->ir_rx_work);
> +	flush_work_sync(&dev->ir_tx_work);
>  }
>  
>  static void cx23885_input_ir_close(struct rc_dev *rc)

