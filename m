Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab0INXCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 19:02:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24469 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab0INXCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 19:02:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:
	content-transfer-encoding:x-system-of-record;
	b=Ckifjznk2AjeOjqzmW4cNCUAibPIGorKxqyGdxDj01iv5Kjp+inQZkhJAjEnXOfGv
	j8dQcZ1QzQ1hItC8n4haw==
Subject: Re: VFS scalability git tree
From: Frank Mayhar <fmayhar@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100914222612.GA23871@infradead.org>
References: <20100722190100.GA22269@amd> <20100730091226.GA10437@amd>
	 <1280795279.3966.47.camel@localhost.localdomain>
	 <20100803054400.GA7398@amd>  <20100914222612.GA23871@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Google, Inc.
Date: Tue, 14 Sep 2010 16:02:32 -0700
Message-ID: <1284505352.26440.7.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 18:26 -0400, Christoph Hellwig wrote:
> Nick,
> 
> what's the plan for going ahead with the VFS scalability work?  We're
> pretty late in the 2.6.36 cycle now and it would be good to get the next
> batch prepared and reivew so that it can get some testing in -next.
> 
> As mentioned before my preference would be the inode lock splitup and
> related patches - they are relatively simple and we're already seeing
> workloads where inode_lock really hurts in the writeback code.

For the record, while I've been quiet here (really busy) I have run a
bunch of pretty serious tests against the original set of patches (note:
_not_ the latest bits in Nick's tree, I have those queued up but haven't
gotten to them yet).  So far I haven't seen any instability at all.

(I did see one case in which a test that does a _lot_ of network traffic
with tons of sockets saw a 20+% performance hit on a system with a
relatively moderate number of cores but I haven't had the time to
characterize it better and want to test against the newer bits in any
event.  Sorry to be so vague, I can't really be more specific at this
point.  Nailing this down is _also_ on my list.)

Performance notwithstanding, I'm impressed with the stability of those
original patches.  I've run VM stress tests against it, FS stress tests,
lots of benchmarks and a bunch of other stuff and it's solid, no crashes
nor any anomalous behavior.

That being the case, I would vote enthusiastically for bringing in the
inode_lock splitup as soon as is feasible.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

