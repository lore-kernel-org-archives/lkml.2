Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2BQWRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:17:31 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33951 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2BQWRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:17:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.221.137 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Fri, 17 Feb 2012 14:17:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] block: make blk-throttle preserve the issuing task
 on delayed bios
Message-ID: <20120217221725.GK29414@google.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-10-git-send-email-tj@kernel.org>
 <20120217215814.GH26620@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217215814.GH26620@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 17, 2012 at 04:58:14PM -0500, Vivek Goyal wrote:
> blk-throttle is just one of places where we lose submitter's context info.
> There are others too.

Yeah, sure.  We do that in quite a few places now.

> As Kent said, doing this at more generic level will probably make sense.
> I think dm layer also might benefit from it. We had issues with losing
> this process context info while bio is being submitted with a helper thread.
> 
> https://lkml.org/lkml/2010/10/24/59
> 
> But I guess this will require some changes at dm layer too so that it
> takes extra bio->ioc and bio->blkcg references at cloning time.

Yeah, it just needs to make sure %current's ioc is there and call
bio_associate_current() before passing bios to worker.  We'll get
there.

Thanks.

-- 
tejun
