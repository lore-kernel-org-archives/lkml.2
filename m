Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2HNRfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:35:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48239 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab2HNRfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:35:36 -0400
Date: Tue, 14 Aug 2012 10:35:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, mingo@redhat.com,
        lauro.venancio@openbossa.org, jak@jak-linux.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alasdair Kergon <agk@redhat.com>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Rob Clark <rob@ti.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Sage Weil <sage@inktank.com>
Subject: Re: [PATCH 6/6] workqueue: deprecate WQ_NON_REENTRANT
Message-ID: <20120814173531.GP25632@google.com>
References: <1344908986-18152-1-git-send-email-tj@kernel.org>
 <1344908986-18152-7-git-send-email-tj@kernel.org>
 <2904218.ZgtLmH5Irc@ax5200p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2904218.ZgtLmH5Irc@ax5200p>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 14, 2012 at 07:24:59PM +0200, Marc Dietrich wrote:
> the nvec driver had its own workqueue because we found that it reduced some 
> timimg induced protocol errors. I just tested your patch which uses the system 
> workqueue and I failed to reproduce these protocol errors under stress 
> testing, so I think it's ok.

Thanks, there shouldn't be any difference whether you use system_wq or
your own.

> Because this is a single patch affecting many drivers, is this going through 
> linux-next or some subsystem tree? Maybe it would have been better to split it 
> in one patch per driver. Otherwise ...

I generally think it's better to do quick one time conversion for
things like this, but this patch is rather borderline.  It might be
better to separate out the non trivialones and route them separately.
I'll think more about it.

Thanks.

-- 
tejun
