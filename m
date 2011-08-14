Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1HNIlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 04:41:45 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:50048 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1HNIlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 04:41:44 -0400
Date: Sun, 14 Aug 2011 10:41:02 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: add GENHD_FL_UNPARTITIONABLE
Message-ID: <20110814104102.343713d2@neptune.home>
In-Reply-To: <20110813153237.GD4254@htj.dyndns.org>
References: <20110813153237.GD4254@htj.dyndns.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 August 2011 Tejun Heo <tj@kernel.org> wrote:
> There are cases where suppressing partition scan is useful - e.g. for
> lo devices and pseudo SATA devices which advertise to be a disk but
> get upset on partition scan (some port multiplier control devices show
> such behavior).
> 
> This patch adds GENHD_FL_UNPARTITIONABLE which suppresses partition
> scan regardless of the number of possible partitions.

Hm, would be nice if this could be set automatically for multipathed
devices where active path is being controlled out-of-band (e.g. RDAC)
and the inactive path rejects all IO.

Big question is how to let the kernel know early enough as userspace
does not know about the device before kernel tries to probe partitions.
Probably it would have to be triggered on the scsi-host side.

Bruno
