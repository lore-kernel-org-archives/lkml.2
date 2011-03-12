Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab1CLRlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 12:41:49 -0500
Received: from kroah.org ([198.145.64.141]:40380 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab1CLRl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 12:41:28 -0500
Date: Sat, 12 Mar 2011 09:36:26 -0800
From: Greg KH <greg@kroah.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: l-m <linux-kernel@vger.kernel.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        l-o <linux-omap@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Tuomas Kulve <tuomas@kulve.fi>
Subject: Re: [PATCH] staging: tidspbridge: protect dmm_map properly
Message-ID: <20110312173626.GC24981@kroah.com>
References: <1299889746-16502-1-git-send-email-omar.ramirez@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299889746-16502-1-git-send-email-omar.ramirez@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 06:29:06PM -0600, Omar Ramirez Luna wrote:
> Hi Greg,
> 
> Please consider to apply this patch in the staging tree, as the
> description says it fixes a crash in tidspbridge driver, this bug
> was already present but it seems to have surfaced by recent tests
> made by Felipe and Tuomas.
> 
> It is an urgent fix for 2.6.38.

Heh, it's funny to see such a "urgent" fix take so long to get to me :)

Is it also applicable for .37?

> More on this discussion:
> http://www.gossamer-threads.com/lists/linux/kernel/1351446
> 
> Thanks,
> - omar
> 
> From: Felipe Contreras <felipe.contreras@nokia.com>
> 
> We need to protect not only the dmm_map list, but the individual
> map_obj's, otherwise, we might be building the scatter-gather list with
> garbage. So, use the existing proc_lock for that.
> 
> I observed race conditions which caused kernel panics while running
> stress tests, also, Tuomas Kulve found it happening quite often in
> Gumstix Over. This patch fixes those.
> 
> Cc: Tuomas Kulve <tuomas@kulve.fi>
> Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>
> Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>

How about I send it to Linus for .39 and then add it to the .38-stable
tree when it comes out?

thanks,

greg k-h
