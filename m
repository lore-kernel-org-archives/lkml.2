Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2B0JLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:11:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35163 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2B0JLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:11:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.224.225 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Mon, 27 Feb 2012 18:11:41 +0900
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120227091141.GG3401@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
 <20120224142033.GA5095@redhat.com>
 <20120225214421.GA3401@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120227031146.GA25187@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227031146.GA25187@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 10:11:46PM -0500, Vivek Goyal wrote:
> Ok. This sounds better than embeding work_struct in blkg, I can embed it
> in request_queue and make the worker walk the list of blkg pending 
> alloc of stats. Will try that. Thanks for the idea.

We might not need to make it even per-queue.  Simple global list of
pending blkgs and single work item should work fine, I think.

Thanks.

-- 
tejun
