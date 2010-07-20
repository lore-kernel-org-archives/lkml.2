Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab0GTKlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 06:41:16 -0400
Received: from smtp.nokia.com ([192.100.122.233]:52886 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab0GTKlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 06:41:15 -0400
Subject: Re: [RFC][PATCH 10/16] writeback: simplify bdi code a little
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100718065613.GI23811@infradead.org>
References: <1279284312-2411-1-git-send-email-dedekind1@gmail.com>
	 <1279284312-2411-11-git-send-email-dedekind1@gmail.com>
	 <20100718065613.GI23811@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 13:34:40 +0300
Message-ID: <1279622080.16462.106.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 Jul 2010 10:41:01.0757 (UTC) FILETIME=[0C0A5ED0:01CB27F8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-18 at 02:56 -0400, Christoph Hellwig wrote:
> Looks correct, but I would do this slightly different.  Add a new
> bdi_writeback_start_thread helper, and then call it from the list
> walk as long as there are bdis that need a thread.  Only break
> out of the loop once nothing needs to be done and then sleep.

Well, in order to have small and reviewable patches, I'd like to keep my
path as it is. Indeed, my patch now does one simple thing - removes the
'pending_list' variable, and then some other stuff as a result.

I can do what you suggest on top then, but I do not really see the
elegance of what you suggest: to start the thread, we have to drop the
'bdi_lock', which means we would then have to re-start list walking from
the beginning, which is not nicer than what we have now.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

