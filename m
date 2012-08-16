Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401Ab2HPVci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:32:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48565 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933362Ab2HPVcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:32:36 -0400
Date: Thu, 16 Aug 2012 14:25:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: wei_wang@realsil.com.cn, gregkh@linuxfoundation.org,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, cjb@laptop.org, sameo@linux.intel.com,
        bp@alien8.de
Subject: Re: [PATCH v2 1/2] drivers/mfd: Add realtek pcie card reader driver
Message-ID: <20120816212548.GI24861@google.com>
References: <cover.1344939464.git.wei_wang@realsil.com.cn>
 <81fef7d4f337f6d8e3365752bbb3ef87302b82a0.1344939464.git.wei_wang@realsil.com.cn>
 <201208150640.54561.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208150640.54561.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 06:40:54AM +0000, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, wei_wang@realsil.com.cn wrote:
> > +
> > +void rtsx_pci_start_run(struct rtsx_pcr *pcr)
> > +{
> > +       /* If pci device removed, don't queue idle work any more */
> > +       if (pcr->remove_pci)
> > +               return;
> > +
> > +       if (pcr->state != PDEV_STAT_RUN) {
> > +               pcr->state = PDEV_STAT_RUN;
> > +               pcr->ops->enable_auto_blink(pcr);
> > +       }
> > +
> > +       mod_timer(&pcr->idle_timer, jiffies + msecs_to_jiffies(200));
> > +}
> > +EXPORT_SYMBOL_GPL(rtsx_pci_start_run);
> 
> One more comment on the mod_timer/queue_work combination: I just saw that
> Tejun Heo posted a series to introduce a new mod_delayed_work() helper.
> 
> Once that goes in, it would be best to start using it here.

mod_delayed_work() is now in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git wq-mod_delayed

The branch is stable and will be pushed during for-3.7 merge window.
Please feel free to pull as necessary.

Thanks.

-- 
tejun
