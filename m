Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2GKGoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:44:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:52870 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab2GKGoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:44:13 -0400
Message-ID: <4FFD1FE7.6010504@huawei.com>
Date: Wed, 11 Jul 2012 14:40:39 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <liuj97@gmail.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
Subject: Re: [RFC PATCH 05/14] PCI: add access functions for PCIe capabilities
 to hide PCIe spec differences
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com> <1341935655-5381-1-git-send-email-jiang.liu@huawei.com> <1341935655-5381-6-git-send-email-jiang.liu@huawei.com> <CAErSpo7k3=nUSTR+n1iX0Rddv2FQm+HzcqnC5VHxh1JKUdoNAw@mail.gmail.com> <4FFCEDDE.2080907@huawei.com> <CAErSpo4JrgU2RHoNDWcm13otgdKVXuGxahE0pbuAD73nZvTZFQ@mail.gmail.com>
In-Reply-To: <CAErSpo4JrgU2RHoNDWcm13otgdKVXuGxahE0pbuAD73nZvTZFQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-7-11 11:40, Bjorn Helgaas wrote:

>> Good point. Return success when reading unimplemented registeres, that
>> may simplify code. For we still should return -EINVAL when writing
>> unimplemented registers, right?
> 
> Yeah, I guess it's OK to return -EINVAL when *writing* to an
> unimplemented register.  Hopefully the caller is structured such that
> we don't even try to write in that case.  It'd be interesting to audit
> the callers and explore that, but I haven't done that.
Hi Bjorn,
	Seems it would be better to return error code for unimplemented
registers, otherwise following code will becomes more complex. A special
error code for unimplemented registers, such as -EIO?

static void rtl_disable_clock_request(struct pci_dev *pdev)
{
        u16 ctl;

        if (!pci_pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &ctl)) {
                ctl &= ~PCI_EXP_LNKCTL_CLKREQ_EN;
                pci_pcie_capability_write_word(pdev, PCI_EXP_LNKCTL, ctl);
        }
}

