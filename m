Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2BTVGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:06:52 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61857 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab2BTVGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:06:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.242.39 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Mon, 20 Feb 2012 13:06:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120220210642.GC3538@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
 <20120217223420.GJ26620@redhat.com>
 <20120217224103.GN29414@google.com>
 <20120217225125.GK26620@redhat.com>
 <20120217225735.GP29414@google.com>
 <20120220143622.GB10342@redhat.com>
 <20120220170128.GB7836@mtj.dyndns.org>
 <20120220191604.GC13423@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220191604.GC13423@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 20, 2012 at 02:16:04PM -0500, Vivek Goyal wrote:
> On Mon, Feb 20, 2012 at 09:01:28AM -0800, Tejun Heo wrote:
> > Yeah, AFAICS, if the cloning task hasn't issued IO before, CLONE_IO is
> > ignored.
> 
> Will it make sense to try to allocate and attach io_context and then 
> share it in copy_io()?

Yeap, that's probably what we should do on CLONE_IO.

> Well, you are planning to kill CLONE_IO altogether, so it does not
> make a difference.

Heh, I was just thinking about sending out a RFC patch.  I mean,
CLONE_IO handling that severely broken and nobody noticing for such
long time doesn't look good, right?

Thanks.

-- 
tejun
