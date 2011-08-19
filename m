Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1HSUHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 16:07:18 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52077 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286Ab1HSUHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 16:07:16 -0400
X-Sasl-enc: 3q0sCgFVPpKX7qCJEkX+IUdcR/uKx5JYOJg2pf0jGqvK 1313784435
Date: Fri, 19 Aug 2011 17:07:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, oleg@redhat.com, Jens Axboe <axboe@kernel.dk>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Subject: Re: [PATCH 04/16] freezer: implement and use
 kthread_freezable_should_stop()
Message-ID: <20110819200712.GA19290@khazad-dum.debian.net>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-5-git-send-email-tj@kernel.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011, Tejun Heo wrote:
> Writeback and thinkpad_acpi have been using thaw_process() to prevent
> deadlock between the freezer and kthread_stop(); unfortunately, this
> is inherently racy - nothing prevents freezing from happening between
> thaw_process() and kthread_stop().
> 
> This patch implements kthread_freezable_should_stop() which enters
> refrigerator if necessary but is guaranteed to return if
> kthread_stop() is invoked.  Both thaw_process() users are converted to
> use the new function.
> 
> Note that this deadlock condition exists for many of freezable
> kthreads.  They need to be converted to use the new should_stop or
> freezable workqueue.
> 
> Tested with synthetic test case.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>

For the thinkpad-acpi bits:
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
