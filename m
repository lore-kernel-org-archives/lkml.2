Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2ACShr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:37:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43258 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab2ACShq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:37:46 -0500
Date: Tue, 3 Jan 2012 10:37:41 -0800
From: Tejun Heo <tj@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: block: WARN_ON_ONCE(ev->block <= 0) triggered in
 __disk_unblock_events()
Message-ID: <20120103183741.GE31746@google.com>
References: <CAO+b5-pig48acSXAYKH09QHCL9EtzTis=mpn=OnE=cvCv+0EzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO+b5-pig48acSXAYKH09QHCL9EtzTis=mpn=OnE=cvCv+0EzA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jan 01, 2012 at 05:22:58PM +0000, Bart Van Assche wrote:
> In a workload that involves a lot of scsi_remove_hosts() calls (srp-ha
> patch set stress test) I get the call stack below after about 30 to 50
> iterations. Is this a known issue ? Does this indicate a race
> condition in the block layer ? I can trigger this issue not only with
> 3.2-rc7 but also with 3.1.6. I haven't tried any other kernel versions
> yet.
>
> ------------[ cut here ]------------
> WARNING: at block/genhd.c:1466 __disk_unblock_events+0xf5/0x110()

It's indicating that there were more disk_unblock_events() than
disk_block_events().  Hmmm... weird.  I'll prep a debug patch.

Thanks.

-- 
tejun
