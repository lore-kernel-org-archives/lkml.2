Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab2FFQ4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:56:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14144 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab2FFQ4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:56:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6733"; a="196043556"
Date: Wed, 6 Jun 2012 09:56:51 -0700
From: David Brown <davidb@codeaurora.org>
To: Rahul Bedarkar <rpal143@gmail.com>
Cc: Maya Erez <merez@codeaurora.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 1/1] mmc: block: Add MMC write packing statistics
Message-ID: <20120606165651.GA15102@codeaurora.org>
References: <1338963389-3147-1-git-send-email-merez@codeaurora.org>
 <1338963389-3147-2-git-send-email-merez@codeaurora.org>
 <CA+NV+VknemgROF5DsSVJ8MDUEyMnrM_vtj66nUTKP6ZvxsF+ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+NV+VknemgROF5DsSVJ8MDUEyMnrM_vtj66nUTKP6ZvxsF+ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 12:02:10PM +0530, Rahul Bedarkar wrote:

> > +static ssize_t mmc_wr_pack_stats_read(struct file *filp, char __user *ubuf,
> > +                               size_t cnt, loff_t *ppos)
> > +{
> > +       struct mmc_card *card = filp->private_data;
> > +       struct mmc_wr_pack_stats *pack_stats;
> > +       int i;

> Best practice is to initialize variables at the time of declaration,
> even if you initialize it before using. Many times we forget to do
> that and there could be logical errors.

gcc will often emit a warning if a variable is used before
initialization.  There seems to be a trend amongst kernel developers
to eschew redundant initializations, since they do actually generate
code.  In fact, there is a macro 'uninitialized_var(x)' to suppress
the warning from the compiler when it is incorrect, so that a variable
doesn't have to be initialized when not really needed.

Outside of the kernel, though, I would otherwise agree with you.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
