Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab2LMSY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:24:29 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54455 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab2LMSY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:24:27 -0500
Date: Thu, 13 Dec 2012 10:24:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: "rjw@sisk.pl" <rjw@sisk.pl>, "lenb@kernel.org" <lenb@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "guohanjun@huawei.com" <guohanjun@huawei.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 02/11] drivers/base: Add hotplug framework code
Message-ID: <20121213182422.GB9606@kroah.com>
References: <1355354243-18657-1-git-send-email-toshi.kani@hp.com>
 <1355354243-18657-3-git-send-email-toshi.kani@hp.com>
 <20121212235418.GB22764@kroah.com>
 <1355371365.18964.89.camel@misato.fc.hp.com>
 <20121213042437.GA14240@kroah.com>
 <1355416251.18964.170.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355416251.18964.170.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 09:30:51AM -0700, Toshi Kani wrote:
> On Thu, 2012-12-13 at 04:24 +0000, Greg KH wrote:
> > On Wed, Dec 12, 2012 at 09:02:45PM -0700, Toshi Kani wrote:
> > > On Wed, 2012-12-12 at 15:54 -0800, Greg KH wrote:
> > > > On Wed, Dec 12, 2012 at 04:17:14PM -0700, Toshi Kani wrote:
> > > > > Added hotplug.c, which is the hotplug framework code.
> > > > 
> > > > Again, better naming please.
> > > 
> > > Yes, I will change it to be more specific, something like
> > > "sys_hotplug.c".
> > 
> > Ugh, what's wrong with just a simple "system_bus.c" or something like
> > that, and then put all of the needed system bus logic in there and tie
> > the cpus and other sysdev code into that?
> 
> The issue is that the framework does not provide the system bus
> structure.  This is because the system bus structure is not used for CPU
> and memory initialization at boot (as I explained in my other email).

I understand, please fix that and then you will not have these issues :)

> The framework manages the calling sequence of hotplug operations, which
> is similar to the boot sequence managed by start_kernel(),
> kernel_init(), do_initcalls(), etc.  In such sense, this file might not
> be a good fit for drivers/base, but I could not find a better place for
> it.

Having "similar but slightly different" isn't a good way to do things,
and I think you are trying to solve that problem here, so converting
everything to use the driver model properly will solve these issues for
you, right?

I _really_ don't want to see yet-another-way-to-do-things be created at
all, unless it really really really is special and different for some
reason.  So far, I have yet to be convinced, especially given that your
reasoning for doing this seems to be "to do it correctly would be too
much work so I created another interface".  That isn't going to fly,
sorry.

thanks,

greg k-h
