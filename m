Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939Ab2JLRBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 13:01:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:35127 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab2JLRBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 13:01:47 -0400
Message-ID: <50784CD3.2040008@kernel.dk>
Date: Fri, 12 Oct 2012 11:01:07 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Derek Basehore <dbasehore@chromium.org>
CC: msb@chromium.org, spang@chromium.org, bfreed@chromium.org,
        arscott@chromium.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Remove deadlock in disk_clear_events
References: <1349992327-9747-1-git-send-email-dbasehore@chromium.org>
In-Reply-To: <1349992327-9747-1-git-send-email-dbasehore@chromium.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-11 15:52, Derek Basehore wrote:
> In disk_clear_events, do not put work on system_nrt_freezable_wq. Instead, put
> it on system_nrt_wq.
> 
> There is a race between probing a usb and suspending the device. Since probing a
> usb calls disk_clear_events, which puts work on a frozen workqueue, probing
> cannot finish after the workqueue is frozen. However, suspending cannot finish
> until the usb probe is finished, so we get a deadlock.

Thanks, applied to later inclusion into 3.7. You did not mark this as
stable, though it seems it should be?

-- 
Jens Axboe

