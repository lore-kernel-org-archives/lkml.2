Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2ILJFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:05:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49164 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2ILJFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:05:36 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50504F47.80909@jp.fujitsu.com>
Date: Wed, 12 Sep 2012 18:00:55 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: vgoyal@redhat.com
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, hbabu@us.ibm.com,
        ishii.hironobu@jp.fujitsu.com, martin.wilck@ts.fujitsu.com
Subject: Re: [RFC][PATCH] Reset PCIe devices to address DMA problem on kdump
 with iommu
References: <501BB4EF.7080909@jp.fujitsu.com> <20120803114643.GA28330@redhat.com> <501F4877.5050605@jp.fujitsu.com> <20120806203902.GH25559@redhat.com> <50473306.1070803@jp.fujitsu.com> <20120910143604.GB639@redhat.com> <504F1343.7030607@jp.fujitsu.com> <20120911144323.GF12039@redhat.com>
In-Reply-To: <20120911144323.GF12039@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/11 23:43), Vivek Goyal wrote:
> On Tue, Sep 11, 2012 at 07:32:35PM +0900, Takao Indoh wrote:
>
> [..]
>> I'll post new patch which clears bus master bit and resets devices in
>> second kernel.
>>
>> As to the boot parameter to enable this function, you suggested using
>> reset_devices. I found that on a certain platform resetting devices
>> caused PCIe error due to a hardware bug. Therefore I think we need
>> new parameter apart from reset_devices to disable this function on
>> such a machine.
>
> Can you explain a bit more how the error happens. I still don't think
> that because of a bug in a platform somewhere we should be introducing
> a separate command line parameter and not reuse the exisiting one. Also
> you have not explained what's the bug and how a new parameter will
> avoid the bug.

The bug I mentioned is that ACS Violation occurs at PCIe switch when
reading PCI configuration after device reset. I got information that
this violation is caused by PCIe switch bug. The machine becomes fatal
status by this error.

The reason why I try to introduce new parameter is that I want to avoid
regression by this patch. Let's say this patch was included in kernel
and its reset function was enabled by reset_devices as you said. AFAIK
reset_devices is always needed for kdump, so it means that devices are
always reset at kdump boot time. It causes a regression that system
always becomes abnormal status when we run kdump on the machine which has
a bug I mentioned.

To avoid this regression, I want to separate reset_devices from this
reset function. Or how about this?
- if user specify reset_devices, devices are reset by this patch, as you
   said.
- To avoid a regression I said, add new parameter like "pci=noreset".
   If this parameter is specified, the reset function I add is disabled
   and we can avoid regression.

Thanks,
Takao Indoh

