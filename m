Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1FPG5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 02:57:45 -0400
Received: from linux-sh.org ([111.68.239.195]:52770 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab1FPG5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 02:57:43 -0400
Date: Thu, 16 Jun 2011 15:56:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jaya Kumar <jayalk@intworks.biz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: don't use flush_scheduled_work() in fb_defio
Message-ID: <20110616065617.GB25825@linux-sh.org>
References: <20110615145721.GA8141@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615145721.GA8141@htj.dyndns.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 04:57:21PM +0200, Tejun Heo wrote:
> flush_scheduled_work() in on the way out.  fb_deferred_io_cleanup()
> can simply sync-cancel info->deferred_work instead of cancel +
> flush_scheduled_work().  Drop flush_scheduled_work() usage.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jaya Kumar <jayalk@intworks.biz>
> ---
> Compile tested.  I'm planning on marking flush_scheduled_work()
> deprecated in linux-next so it would be great if this can show up
> there soonish.  Thank you.
> 
>  drivers/video/fb_defio.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
I've applied it to my fbdev tree, so it should show up in -next as of
tomorrow.

In the future, please also Cc linux-fbdev@vger.kernel.org on these
things, as they're likely to be overlooked otherwise.
