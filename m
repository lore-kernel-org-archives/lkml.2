Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab1IBUkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:40:52 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:46017
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab1IBUku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:40:50 -0400
Message-ID: <4E613F4B.8030502@kernel.dk>
Date: Fri, 02 Sep 2011 14:40:43 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Maxim Patlasov <maxim.patlasov@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cfq: queued/in_driver stats
References: <1314982962-30271-1-git-send-email-maxim.patlasov@gmail.com>
In-Reply-To: <1314982962-30271-1-git-send-email-maxim.patlasov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-02 11:02, Maxim Patlasov wrote:
> The patch implements gathering and exporting statistics for cfqd->rq_queued
> and cfqd->rq_in_driver. Average values of queued/in_driver are visible via
> /sys/.../iosched/queued_avg and /sys/.../iosched/in_driver_avg correspondingly.
> The output is in form of "%lu.%02lu %lu.%02lu %lu.%02lu" where the first
> value represents average over 1 sec interval, the second - over 5 sec,
> the third - over 15 sec.
> 
> The patch also exports cfqd->hw_tag to be seen via /sys/.../iosched/hw_tag.
> 
> Seeing hw_tag is useful to be sure that cfq detected NCQ correctly on given
> h/w. queued/in_driver stats are useful to debug performance problems: e.g.,
> if you know that fast h/w raid is able to concurrently process many requests
> quite effectively, but at the same time you observe high queued average and
> low in_driver one, you can suggest that cfq underloads h/w raid.
> 
> Changes since first version: do_div was used wrongly, fixed.

Seems like an awful lot of code for something that could be gleaned
with blktrace?

-- 
Jens Axboe

