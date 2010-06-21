Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab0FUUAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:00:13 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56282 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758191Ab0FUUAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:00:11 -0400
Message-ID: <4C1FC4CA.7030007@kernel.dk>
Date: Mon, 21 Jun 2010 22:00:10 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cfq: always return false from should_idle if slice_idle
 is set to zero
References: <1277149789-4493-1-git-send-email-jmoyer@redhat.com> <1277149789-4493-2-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1277149789-4493-2-git-send-email-jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/10 21.49, Jeff Moyer wrote:
> Hi,
> 
> In testing a competing fsync-ing process and a sequential reader on
> mid-grade storage, I found that cfq was incapable of achieving the I/O
> rates of deadline, no matter how it was tuned.  Investigation, and insight
> from Vivek (mostly the latter), led to identifying that we were still
> idling for the last queue in the service tree.
> 
> Modifying cfq_should_idle to not idle when slice_idle is set to zero got
> us much closer to the performance of deadline for this workload.  I have
> one follow-on patch that gets us on-par with deadline, but I think this
> patch stands alone.
> 
> Comments, as always, are appreciated.

This looks good.

-- 
Jens Axboe

