Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2FRLkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:40:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62210 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2FRLkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:40:45 -0400
Date: Mon, 18 Jun 2012 19:48:41 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Why does ionice(1) ban the user to set back to 'none' class?
Message-ID: <20120618114841.GA4855@gmail.com>
Mail-Followup-To: Jens Axboe <axboe@kernel.dk>,
	Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I meet a problem when I use ionice(1) to adjust a process's io priority.
I do the following operations:

$ ionice -p${pid}
none: prio 0
$ ionice -p${pid} -c2 -n4
$ ionice -p${pid}
best-effort: prio 4
$ ionice -p${pid} -c0 -n0
$ ionice -p${pid}
best-effort: prio 0

So I cannot set scheduling class back to 'none'.  If I call ioprio_set(2)
directly, it will be fine.  But if I use ionice(1), I cannot change it.  I
read the docs about ionice in [1].  I notice this code:

switch (ioprio_class) {
	case IOPRIO_CLASS_NONE:
		ioprio_class = IOPRIO_CLASS_BE;
                               ^^^^^^^^^^^^^^^^
                               *It means that we cannot set back to none.*
		break;
	case IOPRIO_CLASS_RT:
	case IOPRIO_CLASS_BE:
		break;
	case IOPRIO_CLASS_IDLE:
		ioprio = 7;
		break;
	default:
		printf("bad prio class %d\n", ioprio_class);
		return 1;
}

My question is why we need to ban the user to set back to 'none'.  Is there
some reasons?  Thank you.

[Sorry, I don't subscribe linux-doc and linux-kernel mailing list.
Please CC to me.]

1. ${linux_src}/Documentation/block/ioprio.txt.

Regards,
Zheng
