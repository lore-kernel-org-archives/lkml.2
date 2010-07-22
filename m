Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab0GVJbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 05:31:47 -0400
Received: from smtp.nokia.com ([192.100.122.233]:51092 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab0GVJbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 05:31:45 -0400
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Dave Chinner <dchinner@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20100722090023.GA7692@infradead.org>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
	 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
	 <1279712741.2306.36.camel@localhost> <20100722004155.GZ32635@dastard>
	 <20100722090023.GA7692@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 12:24:13 +0300
Message-ID: <1279790653.3044.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Jul 2010 09:31:00.0560 (UTC) FILETIME=[98C21500:01CB2980]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 05:00 -0400, Christoph Hellwig wrote:
> 	 if (wakeup_bdi) {
> 	 	spin_lock(&bdi->wb_lock);
> 		if (bdi->wb.task) {
> 			trace_writeback_wake_thread(bdi);
> 			wake_up_process(bdi->wb.task);
> 		} else {
> 			trace_writeback_wake_forker_thread(bdi);
> 			wake_up_process(default_backing_dev_info.wb.task);
> 		}
> 		spin_unlock(&bdi->wb_lock);
> 	}

Side note: I've noticed you've made the optimistic "if" condition first,
which is better, and I'll also amend this in v3.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

