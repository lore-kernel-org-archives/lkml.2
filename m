Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0GYKsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 06:48:35 -0400
Received: from smtp.nokia.com ([192.100.122.230]:63724 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0GYKse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 06:48:34 -0400
Subject: Re: [PATCHv5 12/15] writeback: optimize periodic bdi thread wakeups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1280046581-23623-13-git-send-email-dedekind1@gmail.com>
References: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
	 <1280046581-23623-13-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Jul 2010 13:41:09 +0300
Message-ID: <1280054469.9990.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Jul 2010 10:48:26.0479 (UTC) FILETIME=[E92E4FF0:01CB2BE6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-25 at 11:29 +0300, Artem Bityutskiy wrote:
> +static void wakeup_timer_fn(unsigned long data)
> +{
> +	struct backing_dev_info *bdi = (struct backing_dev_info *)data;
> +
> +	spin_lock(&bdi->wb_lock);
> +	if (bdi->wb.task) {
> +		wake_up_process(bdi->wb.task);
> +	} else {
> +		/*
> +		 * When bdi tasks are inactive for long time, they are killed.
> +		 * In this case we have to wake-up the forker thread which
> +		 * should create and run the bdi thread.
> +		 */
> +		wake_up_process(default_backing_dev_info.wb.task);
> +	}
> +	spin_unlock(&bdi->wb_lock);
> +}

OK, since now we use this lock in a timer, this should become a
spin_lock_bh().

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

