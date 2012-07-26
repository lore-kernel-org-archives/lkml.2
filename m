Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2GZVng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:43:36 -0400
Received: from 50-193-208-193-static.hfc.comcastbusiness.net ([50.193.208.193]:55227
	"EHLO tetsuo.zabbo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2GZVne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:43:34 -0400
Date: Thu, 26 Jul 2012 14:43:33 -0700
From: Zach Brown <zab@zabbo.net>
To: Ankit Jain <jankit@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        Al Viro <viro@zeniv.linux.org.uk>, bcrl@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Make io_submit non-blocking
Message-ID: <20120726214333.GF17633@lenny.home.zabbo.net>
References: <500E89D1.9010303@suse.de>
 <20120724223110.GQ23387@dastard>
 <20120724225026.GA21691@infradead.org>
 <50119FEA.4060806@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50119FEA.4060806@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 01:22:10AM +0530, Ankit Jain wrote:

> I should probably be doing better tests, any suggestions on what or
> how I can test?

Well, is the test actually *doing* anything with these IOs?

Calling io_submit() and then immediately waiting for completion is the
best case for offloading work to threads inside io_submit().  It's
likely that the kernel thread will then get a chance to run and submit
the IO and you won't have lost much time since the io_submit() queued
the work.

So try saturating the cpus while the tests are running.  Give the kernel
aio submission threads some competition for run time on the cpus.

Maybe with the cpuio bits of fio?  I haven't used that myself but the
description of it in its README/HOWTO files are using all the right
words :).

- z
