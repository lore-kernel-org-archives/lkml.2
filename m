Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab0LMPEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:04:53 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:51180 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab0LMPEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:04:52 -0500
Date: Mon, 13 Dec 2010 16:04:50 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] fs/splice: Pull buf->ops->confirm() from
	splice_from_pipe actors
Message-ID: <20101213150450.GA12865@rere.qmqm.pl>
References: <17eaa416d82b1c57f70443e56ad22feb3c3a3a6f.1292184347.git.mirq-linux@rere.qmqm.pl> <4D0621CB.2010809@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D0621CB.2010809@fusionio.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 02:38:19PM +0100, Jens Axboe wrote:
> On 2010-12-12 22:23, Micha³ Miros³aw wrote:
> > This patch pulls calls to buf->ops->confirm() from all actors passed
> > (also indirectly) to splice_from_pipe_feed().
> Why? The point of ->confirm() is to ensure that the contents are
> stable, otherwise the pages in the pipe could merely be in flight.
> It's needed if you need to actually look at the data, rather than just
> reference it.

I should have put this more clearly in the patch description:
the ->confirm() call is moved to splice_from_pipe_feed(), so that every
actor has its data guaranteed to be stable before it runs.

Best Regards,
Micha³ Miros³aw
