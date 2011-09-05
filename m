Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab1IEIhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 04:37:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44758 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1IEIhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 04:37:05 -0400
MIME-Version: 1.0
In-Reply-To: <4E613F4B.8030502@kernel.dk>
References: <1314982962-30271-1-git-send-email-maxim.patlasov@gmail.com>
	<4E613F4B.8030502@kernel.dk>
Date: Mon, 5 Sep 2011 12:37:04 +0400
Message-ID: <CA+X1aCTPh0jORkk=xrOmQLiGokTTEW0y1Du0uXmqWQUa=W84Fw@mail.gmail.com>
Subject: Re: [PATCH v2] cfq: queued/in_driver stats
From: Maxim Patlasov <maxim.patlasov@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens,

>> The patch implements gathering and exporting statistics for cfqd->rq_queued
>> and cfqd->rq_in_driver. Average values of queued/in_driver are visible via
>> ...
> Seems like an awful lot of code for something that could be gleaned
> with blktrace?

I agree, from the view of keeping code simple, it's simpler to extend
existing blktrace logging like this:

-	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "activate rq, drv=%d",
-		     cfqd->rq_in_driver);
+	cfq_log_cfqq(cfqd, RQ_CFQQ(rq), "activate rq, drv=%d queued=%d",
+		     cfqd->rq_in_driver, cfqd->rq_queued);

and to print cfqd->hw_tag somewhere.

Thanks,
Maxim
