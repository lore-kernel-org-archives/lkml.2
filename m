Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab0LNUNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:13:04 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:37948 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759908Ab0LNUNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:13:02 -0500
X-ASG-Debug-ID: 1292357580-6da39e4d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D07CFC7.6050209@fusionio.com>
Date: Tue, 14 Dec 2010 21:12:55 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] fs/splice: Pull buf->ops->confirm() from  splice_from_pipe
 actors
References: <17eaa416d82b1c57f70443e56ad22feb3c3a3a6f.1292184347.git.mirq-linux@rere.qmqm.pl> <4D0621CB.2010809@fusionio.com> <20101213150450.GA12865@rere.qmqm.pl>
X-ASG-Orig-Subj: Re: [PATCH] fs/splice: Pull buf->ops->confirm() from  splice_from_pipe
 actors
In-Reply-To: <20101213150450.GA12865@rere.qmqm.pl>
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 8bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1292357580
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4999 1.0000 0.0000
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.49432
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-13 16:04, Micha³ Miros³aw wrote:
> On Mon, Dec 13, 2010 at 02:38:19PM +0100, Jens Axboe wrote:
>> On 2010-12-12 22:23, Micha³ Miros³aw wrote:
>>> This patch pulls calls to buf->ops->confirm() from all actors passed
>>> (also indirectly) to splice_from_pipe_feed().
>> Why? The point of ->confirm() is to ensure that the contents are
>> stable, otherwise the pages in the pipe could merely be in flight.
>> It's needed if you need to actually look at the data, rather than just
>> reference it.
> 
> I should have put this more clearly in the patch description:
> the ->confirm() call is moved to splice_from_pipe_feed(), so that every
> actor has its data guaranteed to be stable before it runs.

OK, that makes more sense. I'll queue it up.

-- 
Jens Axboe

