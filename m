Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2BQXGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 18:06:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41592 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2BQXGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 18:06:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.195.99 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Fri, 17 Feb 2012 15:06:43 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120217230643.GQ29414@google.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
 <20120217223420.GJ26620@redhat.com>
 <20120217224103.GN29414@google.com>
 <20120217225615.GL26620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217225615.GL26620@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 05:56:15PM -0500, Vivek Goyal wrote:
> BTW, blk-throttle mangling the context, is a real problem you are facing
> or it is just one of things which is nice to fix.

Yeah, it is a real problem which makes blk-throttle useless if cfq
propio is in use.

> If a cgroup is being throttled do people really care about the
> iopriority of original task that much. (Given the fact that
> iopriority helps only so much and kills performance on fast
> storage).

Yeap, apparently, people wanna apply hard limits on top of propio.
Besides, it's just bad to mangle cgroup *randomly* as the current code
does.

Thanks.

-- 
tejun
