Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab0FUT7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:59:51 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56274 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab0FUT7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:59:50 -0400
Message-ID: <4C1FC4B4.3060700@kernel.dk>
Date: Mon, 21 Jun 2010 21:59:48 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cfq: allow dispatching of both sync and async I/O
 together
References: <1277149789-4493-1-git-send-email-jmoyer@redhat.com> <1277149789-4493-3-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1277149789-4493-3-git-send-email-jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/10 21.49, Jeff Moyer wrote:
> Hi,
> 
> In testing a workload that has a single fsync-ing process and another
> process that does a sequential buffered read, I was unable to tune CFQ
> to reach the throughput of deadline.  This patch, along with the previous
> one, brought CFQ in line with deadline when setting slice_idle to 0.
> 
> I'm not sure what the original reason for not allowing sync and async
> I/O to be dispatched together was.  If there is a workload I should be
> testing that shows the inherent problems of this, please point me at it
> and I will resume testing.  Until and unless that workload is identified,
> please consider applying this patch.

The problematic case is/was a normal SATA drive with a buffered
writer and an occasional reader. I'll have to double check my
mail tomorrow, but iirc the issue was that the occasional reader
would suffer great latencies since service times for that single
IO would be delayed at the drive side. It could perhaps just be
a bug in how we handle the slice idling on the read side when the
IO gets delayed initially.

So if my memory is correct, google for the fsync madness and
interactiveness thread that we had some months ago and which
caused a lot of tweaking. The commit adding this is
5ad531db6e0f3c3c985666e83d3c1c4d53acccf9 and was added back
in July last year. So it was around that time that the mails went
around.


-- 
Jens Axboe

