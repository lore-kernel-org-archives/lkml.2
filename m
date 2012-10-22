Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab2JVTTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:19:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:58482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab2JVTTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:19:43 -0400
Message-ID: <50859C4D.7050309@kernel.dk>
Date: Mon, 22 Oct 2012 21:19:41 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org,
        SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [patch/rfc/rft] sd: allocate request_queue on device's local
 numa node
References: <x49pq4axre1.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49pq4axre1.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-22 21:01, Jeff Moyer wrote:
> Hi,
> 
> All of the infrastructure is available to allocate a request_queue on a
> particular numa node, but it isn't being utilized at all.  Wire up the
> sd driver to allocate the request_queue on the HBA's local numa node.
> 
> This is a request for comments and testing (I've built and booted it,
> nothing more).  I believe that this should be a performance win, but I
> have no numbers to back it up as yet.  Suggestions for workloads to test
> are welcome.

Would seem pointless _not_ to do it, if we have the info. Some
scsi_debug non-delay fio microbenchmark should show it easily. Combine
with perf as needed to verify.


-- 
Jens Axboe

