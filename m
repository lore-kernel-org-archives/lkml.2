Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab2BOPeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:34:01 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47154 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2BOPd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:33:58 -0500
Date: Wed, 15 Feb 2012 07:33:55 -0800
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org, Jean Pihet <jean.pihet@newoldbits.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 2/2] PM / QoS: unconditionally build the per-device
 constraints feature
Message-ID: <20120215153355.GD25163@gs62>
Reply-To: markgross@thegnar.org
References: <1328603646-2714-1-git-send-email-j-pihet@ti.com>
 <1328603646-2714-3-git-send-email-j-pihet@ti.com>
 <20120212020757.GF18742@gs62>
 <201202122227.39949.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202122227.39949.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 10:27:39PM +0100, Rafael J. Wysocki wrote:
> On Sunday, February 12, 2012, mark gross wrote:
> > why are these two patches?
> > 
> > I think you could squash them into one and it would be just fine.
> 
> Well, what sense does _device_ PM QoS make without CONFIG_PM?

I forgot about device pm qos.  

your right.

--mark

> Rafael
> 
> 
> > On Tue, Feb 07, 2012 at 09:34:06AM +0100, Jean Pihet wrote:
> > > The per-device PM QoS feature depends on CONFIG_PM which depends
> > > on PM_SLEEP || PM_RUNTIME. This breaks CPU C-states with kernels
> > > not having these CONFIGs.
> > > 
> > > This patch allows the feature in all cases.
> > > 
> > > Signed-off-by: Jean Pihet <j-pihet@ti.com>
> > > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > Cc: Mark Gross <markgross@thegnar.org>
> > > ---
> > >  drivers/base/power/Makefile |    3 ++-
> > >  include/linux/pm_qos.h      |   39 ---------------------------------------
> > >  2 files changed, 2 insertions(+), 40 deletions(-)
> > > 
> > > diff --git a/drivers/base/power/Makefile b/drivers/base/power/Makefile
> > > index 2e58ebb..312eb65 100644
> > > --- a/drivers/base/power/Makefile
> > > +++ b/drivers/base/power/Makefile
> > > @@ -1,4 +1,5 @@
> > > -obj-$(CONFIG_PM)	+= sysfs.o generic_ops.o common.o qos.o
> > > +obj-y			+= qos.o
> > > +obj-$(CONFIG_PM)	+= sysfs.o generic_ops.o common.o
> > >  obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.o
> > >  obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
> > >  obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
> > > diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
> > > index 105be69..37b017a 100644
> > > --- a/include/linux/pm_qos.h
> > > +++ b/include/linux/pm_qos.h
> > > @@ -77,7 +77,6 @@ int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier);
> > >  int pm_qos_request_active(struct pm_qos_request *req);
> > >  s32 pm_qos_read_value(struct pm_qos_constraints *c);
> > >  
> > > -#ifdef CONFIG_PM
> > >  s32 __dev_pm_qos_read_value(struct device *dev);
> > >  s32 dev_pm_qos_read_value(struct device *dev);
> > >  int dev_pm_qos_add_request(struct device *dev, struct dev_pm_qos_request *req,
> > > @@ -94,43 +93,5 @@ void dev_pm_qos_constraints_init(struct device *dev);
> > >  void dev_pm_qos_constraints_destroy(struct device *dev);
> > >  int dev_pm_qos_add_ancestor_request(struct device *dev,
> > >  				    struct dev_pm_qos_request *req, s32 value);
> > > -#else
> > > -static inline s32 __dev_pm_qos_read_value(struct device *dev)
> > > -			{ return 0; }
> > > -static inline s32 dev_pm_qos_read_value(struct device *dev)
> > > -			{ return 0; }
> > > -static inline int dev_pm_qos_add_request(struct device *dev,
> > > -					 struct dev_pm_qos_request *req,
> > > -					 s32 value)
> > > -			{ return 0; }
> > > -static inline int dev_pm_qos_update_request(struct dev_pm_qos_request *req,
> > > -					    s32 new_value)
> > > -			{ return 0; }
> > > -static inline int dev_pm_qos_remove_request(struct dev_pm_qos_request *req)
> > > -			{ return 0; }
> > > -static inline int dev_pm_qos_add_notifier(struct device *dev,
> > > -					  struct notifier_block *notifier)
> > > -			{ return 0; }
> > > -static inline int dev_pm_qos_remove_notifier(struct device *dev,
> > > -					     struct notifier_block *notifier)
> > > -			{ return 0; }
> > > -static inline int dev_pm_qos_add_global_notifier(
> > > -					struct notifier_block *notifier)
> > > -			{ return 0; }
> > > -static inline int dev_pm_qos_remove_global_notifier(
> > > -					struct notifier_block *notifier)
> > > -			{ return 0; }
> > > -static inline void dev_pm_qos_constraints_init(struct device *dev)
> > > -{
> > > -	dev->power.power_state = PMSG_ON;
> > > -}
> > > -static inline void dev_pm_qos_constraints_destroy(struct device *dev)
> > > -{
> > > -	dev->power.power_state = PMSG_INVALID;
> > > -}
> > > -static inline int dev_pm_qos_add_ancestor_request(struct device *dev,
> > > -				    struct dev_pm_qos_request *req, s32 value)
> > > -			{ return 0; }
> > > -#endif
> > >  
> > >  #endif
> > 
> > 
> 
