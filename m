Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613Ab2BNNjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 08:39:04 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54368 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2BNNjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 08:39:01 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 14 Feb 2012 14:38:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, jbottomley@parallels.com,
        linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>,
        Axel Theilmann <theilmann@pre-sense.de>, linux-kernel@vger.kernel.org
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
Message-ID: <20120214143800.69703df9@stein>
In-Reply-To: <CAO+b5-pCW-F1nD365TnEiAfoN7zKB4zXkk3uO6p5QyUPY2icsA@mail.gmail.com>
References: <4EE8E419.8010000@pre-sense.de>
	<CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com>
	<20111225215804.03ef9402@stein>
	<4F3A46DD.8030305@ce.jp.nec.com>
	<CAO+b5-pCW-F1nD365TnEiAfoN7zKB4zXkk3uO6p5QyUPY2icsA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 14 Bart Van Assche wrote:
> On Tue, Feb 14, 2012 at 12:34 PM, Jun'ichi Nomura
> <j-nomura@ce.jp.nec.com> wrote:
> > While scsi_device is propery refcounted object,
> > q->queuedata is set to NULL by scsi_remove_device() asynchronously.
> > So every reader of scsi_device's q->queuedata should always check it.
> 
> As far as I can see this patch narrows the race window but doesn't fix
> the race. At least sd_prep_fn() still reads queuedata and if I'm not
> mistaken that read races with scsi_remove_device(). Has it been
> considered to modify scsi_remove_device() and scsi_request_fn() such
> that device removal is communicated from the former to the latter in
> another way than by clearing queuedata ?

Or asked differently, *what* is supposed to serialize the ->queuedata
accesses?

(If it is the BKL -- well, some bleeding edge kernel versions lack it,
sources say.)
-- 
Stefan Richter
-=====-===-- --=- -===-
http://arcgraph.de/sr/
