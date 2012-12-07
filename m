Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423958Ab2LGCdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:33:54 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:43685 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422821Ab2LGCdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:33:53 -0500
Message-ID: <1354847118.21116.33.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH v3 0/3] acpi: Introduce prepare_remove device
 operation
From: Toshi Kani <toshi.kani@hp.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Hanjun Guo <guohanjun@huawei.com>,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        linux-acpi@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, rjw@sisk.pl, lenb@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Tang Chen <tangchen@cn.fujitsu.com>,
        Liujiang <jiang.liu@huawei.com>, Huxinwei <huxinwei@huawei.com>
Date: Thu, 06 Dec 2012 19:25:18 -0700
In-Reply-To: <50C0CC2A.1010603@gmail.com>
References: <1353693037-21704-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
	     <50B5EFE9.3040206@huawei.com>
	    <1354128096.26955.276.camel@misato.fc.hp.com>
	   <50B6E936.2080308@huawei.com> <1354228028.7776.56.camel@misato.fc.hp.com>
	   <50BC29C6.6050706@huawei.com>
	 <1354579848.21585.54.camel@misato.fc.hp.com>  <50BDBF5A.8040407@huawei.com>
	 <1354663411.21585.135.camel@misato.fc.hp.com> <50C0CC2A.1010603@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 00:47 +0800, Jiang Liu wrote:
> On 12/05/2012 07:23 AM, Toshi Kani wrote:
> > On Tue, 2012-12-04 at 17:16 +0800, Hanjun Guo wrote:
> >> On 2012/12/4 8:10, Toshi Kani wrote:
> >>> On Mon, 2012-12-03 at 12:25 +0800, Hanjun Guo wrote:
> >>>> On 2012/11/30 6:27, Toshi Kani wrote:
> >>>>> On Thu, 2012-11-29 at 12:48 +0800, Hanjun Guo wrote:
> >>>>>> On 2012/11/29 2:41, Toshi Kani wrote:
:
> >>>> The ACPI specification provides _EDL method to
> >>>> tell OS the eject device list, but still has no method to tell OS the add device
> >>>> list now.
> >>>
> >>> Yes, but I do not think the OS needs special handling for add...
> >>
> >> Hmm, how about trigger a hot add operation by OS ? we have eject interface for OS, but
> >> have no add interface now, do you think this feature is useful? If it is, I think OS
> >> should analyze the dependency first and tell the user.
> > 
> > The OS can eject an ACPI device because a target device is owned by the
> > OS (i.e. enabled).  For hot-add, a target ACPI device is not owned by
> > the OS (i.e. disabled).  Therefore, the OS is not supposed to change its
> > state.  So, I do not think we should support a hot-add operation by the
> > OS.
> We depends on the firmware to provide an interface to actually hot-add the device.
> The sequence is:
> 1) user trigger hot-add request by sysfs interfaces.
> 2) hotplug framework validates conditions for hot-adding (dependency)
> 3) hotplug framework invokes firmware interfaces to request a hot-adding operation.
> 4) firmware sends an ACPI notificaitons after powering on/initializing the device
> 5) OS adds the devices into running system.

Interesting...  In this sequence, I think FW must validate and check the
dependency before sending a SCI.  FW owns unassigned resources and is
responsible for the procedure necessary to enable resources on the
platform.  Such steps are basically platform-specific.  So, I do not
think the common OS code should step into such business.

Thanks,
-Toshi

