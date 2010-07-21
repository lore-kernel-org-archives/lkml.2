Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab0GUUdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:33:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab0GUUdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:33:19 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, czoccolo@gmail.com
Subject: Re: [PATCH 1/3] cfq-iosched: Implment IOPS mode
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
	<1279739181-24482-2-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Jul 2010 16:33:04 -0400
In-Reply-To: <1279739181-24482-2-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Wed, 21 Jul 2010 15:06:19 -0400")
Message-ID: <x497hkod18f.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> o Implement another CFQ mode where we charge queue/group in terms of number
>   of requests dispatched instead of measuring the time. Measuring in terms
>   of time is not possible when we are driving deeper queue depths and there
>   are requests from multiple cfq queues in the request queue.
>
> o This mode currently gets activated if one sets slice_idle=0 and associated
>   disk supports NCQ. Again the idea is that on an NCQ disk with idling disabled
>   most of the queues will dispatch 1 or more requests and then cfq queue
>   expiry happens and we don't have a way to measure time. So start providing
>   fairness in terms of IOPS.
>
> o Currently this primarily is beneficial with cfq group scheduling where one
>   can disable slice idling so that we don't idle on queue and drive deeper
>   request queue deptsh (achieving better throughput), at the same time group
>   idle is enabled so one should get service differentiation among groups.

I like that this is more isolated now.  I'm slowly warming up to it.  I
have one question--just a curiosity, really.  What do you see now for
the reported sl_used in blktrace when slice_idle is zero and the
hardware supports command queueing?

Cheers,
Jeff
