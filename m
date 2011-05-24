Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab1EXMTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:19:09 -0400
Received: from mail.avalus.com ([89.16.176.221]:47604 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab1EXMTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:19:08 -0400
Date: Tue, 24 May 2011 13:19:05 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
cc: Alex Bligh <alex@alex.org.uk>
Subject: Question: block layer and REQ_FLUSH
Message-ID: <4C9FE036825E46DE8121365F@Ximines.local>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/block/writeback_cache_control.txt says:

> The REQ_FLUSH flag can be OR ed into the r/w flags of a bio submitted from
> the filesystem and will make sure the volatile cache of the storage device
> has been flushed before the actual I/O operation is started.  This
> explicitly guarantees that previously completed write requests are on
> non-volatile storage before the flagged bio starts.

>From the block driver's point of view, is it only necessary to ensure
*completed* I/O operations are flushed to disk (as per the text), or
is it also necessary to ensure *in flight* requests (i.e. those that
have not been completed) are flushed to disk too? IE when the block
layer does the flush, does it also wait for in-flight I/O to complete?

IE if the time sequence is
	WRITE1
	WRITE2
	WRITE3
			Complete WRITE2 -> sent to volatile cache
	WRITE4
	REQ_FLUSH

Do I need to only ensure WRITE2 is flushed, or (as I suspect) do I
need to wait for all bios previously submitted to the driver to
complete? If so, from the driver's point of view anyway, should the
guarantee refer to "previously submitted write requests" as opposed
to "previously completed"?

-- 
Alex Bligh
