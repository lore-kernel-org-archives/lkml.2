Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab0GULwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 07:52:51 -0400
Received: from smtp.nokia.com ([192.100.122.233]:35453 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab0GULwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 07:52:50 -0400
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dave Chinner <dchinner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
	 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 14:45:41 +0300
Message-ID: <1279712741.2306.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Jul 2010 11:52:16.0317 (UTC) FILETIME=[2A4A36D0:01CB28CB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 12:31 +0300, Artem Bityutskiy wrote:
>  	spin_unlock(&inode_lock);
> +
> +	if (wakeup_bdi) {
> +		spin_lock(&bdi->wb_lock);
> +		if (!bdi->wb.task)
> +			wake_up_process(default_backing_dev_info.wb.task);
> +		else
> +			wake_up_process(bdi->wb.task);
> +		spin_unlock(&bdi->wb_lock);
> +	}
>  }

Dave,

I do not know whether this stuff will end up in upstream, I did not get
any feed back from Jens so far. But if it will, I'd like to let you know
that the code quoted above is similar to the 'bdi_queue_work()'
function. And the purpose is very similar. But you added a
'trace_writeback_nothread()' call to 'bdi_queue_work()', and I think a
similar call has to be here.

Can I call 'trace_writeback_nothread()'? I guess not. Should I create
another trace point? Any hints/instructions?

Note, the patches are against Jens' tree.

Please, see linux-fsdevel or lkml for the full patch and its purposes.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

