Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab2IZFu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 01:50:56 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52565 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab2IZFuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 01:50:55 -0400
Date: Wed, 26 Sep 2012 10:53:09 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hyeoncheol Lee <hyc.lee@gmail.com>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [QUESTION] Can uprobe_event support @ADDR, $retval,
 offs(FETCHARG)?
Message-ID: <20120926052309.GD27339@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <CANFS6bZtOPe8XbsgC0V0encVLssFShWGhNLZQkCvEhKcNT946w@mail.gmail.com>
 <5062938F.2080703@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <5062938F.2080703@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12092605-5930-0000-0000-00000C783FD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Perhaps, it is not so small things, but at least, we can try.
> In the userspace, memories(pages) can be paged out on swap or
> files. In that case, memory dereference function needs to track
> down the data on the disk and it causes I/O. This means we will
> see the visible performance degradation with tracing.
> And also, sometime a pointer value (address) is broken, in that
> case we have to ensure the address is actually valid before
> accessing it.
> 
> Of cause, without tracking paged-out data, it is easy
> to support, because that is already done in kprobe event.
> I'm not sure how it is useful, because sometimes it will
> fail to access gather the data.
> However it is good for the first step, I think.
> 
> Srikar, what would you think?

I think we should do the best effort basis first. i.e support for
tracking data thats not paged out.
Most times the data that is requested tends to the hot data.

We could look at supporting data that is paged out later.

> 
> BTW, if we can support offs(FETCHARGS), $stack and $stackN
> are also available. ;)
> 

-- 
Thanks and Regards
Srikar Dronamraju

