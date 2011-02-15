Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1BOCEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 21:04:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab1BOCEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 21:04:05 -0500
Date: Tue, 15 Feb 2011 02:03:52 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH][RFC] dm: Do not open log and cow device
	read-write for read-only mappings
Message-ID: <20110215020351.GD5825@agk-dp.fab.redhat.com>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
	Milan Broz <mbroz@redhat.com>
References: <4D57E67E.1030707@redhat.com> <4D57F357.6060708@tao.ma> <4D580A8B.5050508@redhat.com> <20110214103026.GA18742@htj.dyndns.org> <4D591664.6090203@redhat.com> <4D592AD1.6020500@redhat.com> <20110214140940.GM18742@htj.dyndns.org> <4D593AD8.7070901@redhat.com> <20110214154430.GR18742@htj.dyndns.org> <20110215101506.43d41ca8@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215101506.43d41ca8@notabene.brown>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 10:15:06AM +1100, Neil Brown wrote:
> Sounds sensible ... though it is not all that easy to assemble an
> array as 'read-only'....  it is possible though.
 
For dm, it is looking like this change will *require* an upgrade to
userspace LVM tools: some people who just update their kernels without
updating their LVM tools too may find booting their machine fails.  We
are still evaluating exactly which parts of LVM and which classes of
users are affected and how best to deal with this, but I know from
experience that changes where a kernel update requires an associated
userspace update are never well-received and we would normally try to
give plenty of lead time by updating the userspace tools and starting to
get them into the distributions before imposing the kernel change.

> When the array is switched to read-write, do I have to call blkdev_get again
> asking for rw access, then close the old blkdev, or can I 'upgrade'?
 
In dm we upgrade_mode() as you describe.

> If a device has multiple opens: some read-only and some read-write, can I
> find out when the last read-write close is gone?  That would be really useful,
> especially if a filesystem down-graded its open to read-only when it is
> remounted read-only..
 
Likewise, dm has no mechanism for downgrading as yet.

Alasdair

