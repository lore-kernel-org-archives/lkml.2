Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030578Ab2HQC4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:56:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:64088 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964787Ab2HQC4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:56:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,782,1336374000"; 
   d="scan'208";a="203224403"
Date: Fri, 17 Aug 2012 10:56:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, devel@driverdev.osuosl.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: show_uevent() and general protection fault
Message-ID: <20120817025644.GA25843@localhost>
References: <20120713083140.GA19738@localhost>
 <20120713084616.GA20037@localhost>
 <20120717013342.GD21914@kroah.com>
 <20120718051552.GA9124@localhost>
 <20120816172711.GB27415@kroah.com>
 <20120817020608.GA24538@localhost>
 <20120817022939.GA24650@localhost>
 <CACVXFVPL4HON7Ec7SxGLgBDJtJExTJihc1cfVQt05WukU54AEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVPL4HON7Ec7SxGLgBDJtJExTJihc1cfVQt05WukU54AEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:44:37AM +0800, Ming Lei wrote:
> On Fri, Aug 17, 2012 at 10:29 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> >
> > Something obviously wrong here:
> >
> >         env->buflen == 12
> >         env->envp_idx == 1627389952
> >         env->env[0] == NULL
> >
> > I'm not sure where it comes from, but if it's possible for random
> 
> Maybe you can print out the device name by dev_err in show_uevent
> under the situation.

Here it is:

[   68.721580] pci_link PNP0C0F:03: uevent 13 env[1627389952]: PNP0C0F:03/.../PNP0C0F:03

dev_err(dev, "uevent %d env[%d]: %s/.../%s\n", env->buflen, env->envp_idx, top_kobj->name, dev->kobj.name);

Thanks,
Fengguang
