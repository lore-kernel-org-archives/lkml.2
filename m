Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab0EKEYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 00:24:38 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:60648 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab0EKEYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 00:24:36 -0400
Message-ID: <4BE8DBB0.5060701@ct.jp.nec.com>
Date: Tue, 11 May 2010 13:23:12 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 2/2] dm: only initialize full request_queue for request-based
 device
References: <1273532139-23043-1-git-send-email-snitzer@redhat.com> <1273532139-23043-2-git-send-email-snitzer@redhat.com>
In-Reply-To: <1273532139-23043-2-git-send-email-snitzer@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 05/11/2010 07:55 AM +0900, Mike Snitzer wrote:
> Revert back to only allocating a minimalist request_queue structure
> initially (needed for both bio and request-based DM).  Initialization of
> a full request_queue (request_fn, elevator, etc) is deferred until it is
> known that the DM device is request-based.

Thank you for working on this.
However, I still disagree with this patch as we discussed on this thread:
http://marc.info/?t=124990138700003&r=1&w=2
(Exporting a part of queue's features may cause some maintenance costs
 in future.)

As I mentioned on the last email of the thread above (see below),
specifying device type at the device creation time by userspace tools
should make dm code very simple.  So that may be a better approach.

> By the way, another approach to optimizing the memory usage would be
> to determine whether the dm device is bio-based or request-based
> at the device creation time, instead of the table binding time.
> We want the delayed allocation, since kernel can't decide the device
> type until the first table is bound because of the auto-detection
> mechanism.  The auto-detection is good for keeping compatibility with
> existing user-space tools.  But once user-space tools are changed to
> specify device type at the device creation time, we can eventually
> remove the auto-detection.
> Then, kernel can decide device type in alloc_dev(), so
> the initialization code in kernel will become very simple.

Thanks,
Kiyoshi Ueda
