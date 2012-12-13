Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab2LMEFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 23:05:20 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:20972 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2LMEFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 23:05:17 -0500
Message-ID: <1355370975.18964.83.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH 01/11] Add hotplug.h for hotplug framework
From: Toshi Kani <toshi.kani@hp.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: rjw@sisk.pl, lenb@kernel.org, akpm@linux-foundation.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Wed, 12 Dec 2012 20:56:15 -0700
In-Reply-To: <20121212235358.GA22764@kroah.com>
References: <1355354243-18657-1-git-send-email-toshi.kani@hp.com>
	 <1355354243-18657-2-git-send-email-toshi.kani@hp.com>
	 <20121212235358.GA22764@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-12 at 15:53 -0800, Greg KH wrote:
> On Wed, Dec 12, 2012 at 04:17:13PM -0700, Toshi Kani wrote:
> > Added include/linux/hotplug.h, which defines the hotplug framework
> > interfaces used by the framework itself and handlers.
> 
> No, please name this properly, _everything_ is hotpluggable these days,
> and unless you want the whole kernel and all busses and devices to use
> this, then it needs to be named much better than this, sorry.
> 
> We went through this same issue over 10 years ago, please, let's learn
> from our mistakes and not do it again.

Agreed.  I will come up with a better name to avoid the confusion.

> > +/* Add Validate order values */
> > +#define HP_ACPI_BUS_ADD_VALIDATE_ORDER		0	/* must be first */
> 
> This is really ACPI specific, so why not just put it under include/acpi/
> instead?

Yes, this needs to be revisited.  For now, it is defined in the same
file since it helps to manage the ordering when all values are defined
in a same place.  We may need the ordering values defined in each arch
when this framework is used by multiple architectures. 

> And note, PPC and other arches probably do this already (s390?) so to
> exclude them from the beginning would not be a good idea.

Thanks for the suggestion.  I will check other architectures and bring
them to the discussions. 

-Toshi


