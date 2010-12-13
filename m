Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab0LMNiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:38:24 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:59139 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664Ab0LMNiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:38:22 -0500
X-ASG-Debug-ID: 1292247501-6da3249c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D0621CB.2010809@fusionio.com>
Date: Mon, 13 Dec 2010 14:38:19 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] fs/splice: Pull buf->ops->confirm() from splice_from_pipe
  actors
References: <17eaa416d82b1c57f70443e56ad22feb3c3a3a6f.1292184347.git.mirq-linux@rere.qmqm.pl>
X-ASG-Orig-Subj: Re: [PATCH] fs/splice: Pull buf->ops->confirm() from splice_from_pipe
  actors
In-Reply-To: <17eaa416d82b1c57f70443e56ad22feb3c3a3a6f.1292184347.git.mirq-linux@rere.qmqm.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1292247501
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4980 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.49310
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-12 22:23, Michał Mirosław wrote:
> This patch pulls calls to buf->ops->confirm() from all actors passed
> (also indirectly) to splice_from_pipe_feed().

Why? The point of ->confirm() is to ensure that the contents are
stable, otherwise the pages in the pipe could merely be in flight.
It's needed if you need to actually look at the data, rather than just
reference it.

-- 
Jens Axboe

