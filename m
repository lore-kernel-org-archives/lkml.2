Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab2GOQrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 12:47:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54342 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2GOQro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 12:47:44 -0400
Message-ID: <5002F420.40801@gmail.com>
Date: Mon, 16 Jul 2012 00:47:28 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <jiang.liu@huawei.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH 05/14] PCI: add access functions for PCIe capabilities
 to hide PCIe spec differences
References: <CAErSpo70NtEJFaQmDtdTLkSB3fQRNy78juAQO-KbXeceZkunkw@mail.gmail.com> <1341935655-5381-1-git-send-email-jiang.liu@huawei.com> <1341935655-5381-6-git-send-email-jiang.liu@huawei.com> <CAErSpo7k3=nUSTR+n1iX0Rddv2FQm+HzcqnC5VHxh1JKUdoNAw@mail.gmail.com> <4FFCEDDE.2080907@huawei.com> <CAErSpo4JrgU2RHoNDWcm13otgdKVXuGxahE0pbuAD73nZvTZFQ@mail.gmail.com> <4FFD1FE7.6010504@huawei.com> <CAErSpo7ZtrYtz_8iB8=8nbQBtntPtyi8BLg6K+D7mQjnfj-KCg@mail.gmail.com> <4FFE3CEC.80804@huawei.com> <CAErSpo4Adjo8e3YmSJCvNjosouUzuAQqpTm1rm=CAYvFmuDpyg@mail.gmail.com>
In-Reply-To: <CAErSpo4Adjo8e3YmSJCvNjosouUzuAQqpTm1rm=CAYvFmuDpyg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 04:49 AM, Bjorn Helgaas wrote:
>> Hi Bjorn,
>>         It's a little risk to change these PCIe capabilities access
>> functions as void. On some platform with hardware error detecting/correcting
>> capabilities, such as EEH on Power, it would be better to return
>> error code if hardware error happens during accessing configuration registers.
>>         As I know, coming Intel Xeon processor may provide PCIe hardware
>> error detecting capability similar to EEH on power.
> 
> I guess I'm playing devil's advocate here.  As a general rule, people
> don't check the return value of pci_read_config_*() or
> pci_write_config_*().  Unless you change them all, most callers of
> pci_pcie_capability_read_*() and _write_*() won't check the returns
> either.  So I'm not sure return values are an effective way to detect
> those hardware errors.
> 
> How do these EEH errors get detected or reported today?  Do the
> drivers check every config access for success?  Adding those checks
> and figuring out how to handle errors at every possible point doesn't
> seem like a recipe for success.

Hi Bjorn,
	Sorry for later reply, on travel these days.
	Yeah, it's true that most driver doesn't check return values of configuration
access functions, but there are still some drivers which do check return value of
pci_read_config_xxx(). For example, pciehp driver checks return value of CFG access
functions.

	It's not realistic to enhance all drivers, but we may focus on a small set of
drivers for hardwares on specific high-end servers. For RAS features, we can never provide
perfect solutions, so we prefer some improvements. After all a small improvement is still
an improvement:)

	I'm only familiar with PCI on IA64 and x86. For PowerPC, I just know that the OS
may query firmware whether there's some hardware faults if pci_cfg_read_xxx() returns
all 1s. For PCI on IA64, SAL may handle PCI hardware errors and return error code to
pci_cfg_read_xxx(). For x86, I think it will have some mechanisms to report hardware faults
like SAL on IA64.

	So how about keeping consistence with pci_cfg_read_xxx() and pci_user_cfg_read_xxx()?
	Thanks!
	Gerry

