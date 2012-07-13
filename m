Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375Ab2GMBtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 21:49:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:24587 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933082Ab2GMBtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 21:49:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="176742728"
Message-ID: <1342144273.1682.237.camel@rui.sh.intel.com>
Subject: RE: How to use the generic thermal sysfs.
From: Zhang Rui <rui.zhang@intel.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: Wei Ni <wni@nvidia.com>, "Brown, Len" <len.brown@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@ger.kernel.org" <linux-tegra@ger.kernel.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>
Date: Fri, 13 Jul 2012 09:51:13 +0800
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>
References: <1342088573.27605.101.camel@tegra-chromium-2>
	 <4D68720C2E767A4AA6A8796D42C8EB5915287C@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 四, 2012-07-12 at 04:54 -0600, R, Durgadoss wrote:
> Hi,
> 
> > -----Original Message-----
> > From: Wei Ni [mailto:wni@nvidia.com]
> > Sent: Thursday, July 12, 2012 3:53 PM
> > To: Zhang, Rui; Brown, Len; akpm@linux-foundation.org; khali@linux-fr.org;
> > joe@perches.com; R, Durgadoss
> > Cc: linux-kernel@vger.kernel.org; linux-tegra@ger.kernel.org;
> > acourbot@nvidia.com
> > Subject: How to use the generic thermal sysfs.
> > 
> > Hi, all
> > I'm working on the tegra thermal throttling upstream issue.
> > The tegra30 board use the nct1008 as the thermal sensor, and the lm90 is
> > the sensor driver. We want to use the generic thermal sysfs.
> > 
> > My question is where should we register the thermal zone device? We may
> > have two place to do it:
> > 1. register it in the sensor driver, such as lm90.c
> > In this way, the sensor driver doesn't need to export any APIs, such as
> > get_temp.
> 
> This approach is preferred.
> 
> > 2. register in my tegra thermal framework.
> > In this way, the sensor driver need to export some APIs, which are used
> > to register the ops and do any other things.
> 
> What do you mean by "my tegra thermal framework" ? Where does the source
> file for this sit in the mainline kernel ?
> 
I have the same question.
It sounds like that you want to use the tegra thermal framework to do
thermal management instead of the generic thermal layer, right?

IMO, the purpose of the generic thermal layer is
1) do kernel thermal management
2) export unique sysfs I/F to userspace so that users/userspace
applications can take over the thermal management.

what is the benefit to have another driver to do thermal management in
kernel?
If the current thermal management in the generic thermal layer can not
work well on your platform, it is a good chance to enhance the kernel
thermal manager. :)

thanks,
rui

> > 
> > How should I do it?
> > 
> > And in current codes, there have the event notification, in the form of
> > a netlink event. But it's difficult to be used in the kernel, it's
> > normally for the communication with user-space. How about to add a
> > notify call chain for it? So when the sensor has irq alert, it can send
> > a notify to my thermal framework in kernel.
> 
> We are working on a notification API from any generic sensor driver to
> the thermal framework.
> Please have a look at the 'notify_thermal_framework' API in the patch here:
> http://www.spinics.net/lists/linux-acpi/msg36049.html
> 
> Thanks,
> Durga
> 


