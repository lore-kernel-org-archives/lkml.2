Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972Ab2INPs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:48:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758760Ab2INPs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:48:57 -0400
Date: Fri, 14 Sep 2012 11:48:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, hbabu@us.ibm.com,
        ishii.hironobu@jp.fujitsu.com, martin.wilck@ts.fujitsu.com
Subject: Re: [RFC][PATCH] Reset PCIe devices to address DMA problem on kdump
 with iommu
Message-ID: <20120914154817.GE6221@redhat.com>
References: <501BB4EF.7080909@jp.fujitsu.com>
 <20120803114643.GA28330@redhat.com>
 <501F4877.5050605@jp.fujitsu.com>
 <20120806203902.GH25559@redhat.com>
 <50473306.1070803@jp.fujitsu.com>
 <20120910143604.GB639@redhat.com>
 <504F1343.7030607@jp.fujitsu.com>
 <20120911144323.GF12039@redhat.com>
 <50504F47.80909@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50504F47.80909@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 06:00:55PM +0900, Takao Indoh wrote:
> (2012/09/11 23:43), Vivek Goyal wrote:
> >On Tue, Sep 11, 2012 at 07:32:35PM +0900, Takao Indoh wrote:
> >
> >[..]
> >>I'll post new patch which clears bus master bit and resets devices in
> >>second kernel.
> >>
> >>As to the boot parameter to enable this function, you suggested using
> >>reset_devices. I found that on a certain platform resetting devices
> >>caused PCIe error due to a hardware bug. Therefore I think we need
> >>new parameter apart from reset_devices to disable this function on
> >>such a machine.
> >
> >Can you explain a bit more how the error happens. I still don't think
> >that because of a bug in a platform somewhere we should be introducing
> >a separate command line parameter and not reuse the exisiting one. Also
> >you have not explained what's the bug and how a new parameter will
> >avoid the bug.
> 
> The bug I mentioned is that ACS Violation occurs at PCIe switch when
> reading PCI configuration after device reset. I got information that
> this violation is caused by PCIe switch bug. The machine becomes fatal
> status by this error.
> 
> The reason why I try to introduce new parameter is that I want to avoid
> regression by this patch. Let's say this patch was included in kernel
> and its reset function was enabled by reset_devices as you said. AFAIK
> reset_devices is always needed for kdump, so it means that devices are
> always reset at kdump boot time. It causes a regression that system
> always becomes abnormal status when we run kdump on the machine which has
> a bug I mentioned.
> 
> To avoid this regression, I want to separate reset_devices from this
> reset function. Or how about this?
> - if user specify reset_devices, devices are reset by this patch, as you
>   said.
> - To avoid a regression I said, add new parameter like "pci=noreset".
>   If this parameter is specified, the reset function I add is disabled
>   and we can avoid regression.

Can we identify that particular switch in code and not reset it in code.
Introducing new paramenters to avoid bugs really feels odd.

Also, what was the conclusion to avoid double reset. I am assuming that
we don't want to do bus level reset as well as driver level reset based
on reset_devices. 

Thanks
Vivek
