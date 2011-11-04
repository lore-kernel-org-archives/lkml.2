Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab1KDOiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 10:38:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41681 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1KDOiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 10:38:13 -0400
MIME-Version: 1.0
In-Reply-To: <20111104104042.46a33554@stein>
References: <4EB2BC88.3070105@suse.cz>
	<20111103161436.GJ4417@google.com>
	<20111103162634.GK4417@google.com>
	<20111104104042.46a33554@stein>
Date: Fri, 4 Nov 2011 07:38:11 -0700
X-Google-Sender-Auth: 7KhMKahkuQZzaail0gSde5BVQ6M
Message-ID: <CAOS58YMM=75x_hCjRjV8a8j4eSLUuaRf1CEaPvZ=VXz0Qkj6qw@mail.gmail.com>
Subject: Re: [PATCH block/for-next] block: don't call blk_drain_queue() if
 elevator is not up
From: Tejun Heo <tj@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jiri Slaby <jslaby@suse.cz>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 4, 2011 at 2:40 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
>>       /* @q won't process any more request, flush async actions */
>>       del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
>
> What prevents elevator_attach to be called and requests to be inserted
> between 'if (q-elevator)' and 'blk_put_queue(q)'?

The fact that the queue owner has called blk_cleaup_queue()?

Thanks.

-- 
tejun
