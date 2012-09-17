Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab2IQPvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:51:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59798 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2IQPve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:51:34 -0400
Message-ID: <505746FA.5030904@gmail.com>
Date: Mon, 17 Sep 2012 23:51:22 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v1 06/22] PCI: use a global lock to serialize PCI
 root bridge hotplug operations
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com> <1344355862-2726-7-git-send-email-jiang.liu@huawei.com> <CAErSpo5ixjvv3r9wzCXFrDZ790u9_K5KCuQ7GQO3fFuFuiVJZg@mail.gmail.com> <5050AD65.1000801@gmail.com> <CAErSpo4=cakjCQ_Z_nUa2xZQr9KV72kxtsgrW0cjeFN=ktb8zQ@mail.gmail.com>
In-Reply-To: <CAErSpo4=cakjCQ_Z_nUa2xZQr9KV72kxtsgrW0cjeFN=ktb8zQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> I'm not sure why you didn't add a pci_host_bridge_hotplug_lock() in
>>> the sba_init() path, since it looks similar to the drm_open_helper()
>>> path above.  But in any case, I think that would be the wrong thing to
>>> do because it would fix the superficial problem while leaving the
>>> deeper problem of host bridge hot-add not setting the iommu pointer.
> 
>> sba_init is called during system initialization stages through subsys_initcall,
>> so no extra protection for it.
> 
> OK, I see your reasoning.  But I don't agree :)  All the users of an
> interface should use the same locking scheme, even if they're at
> boot-time where we "know" we don't need it.  It's too hard to analyze
> differences, and code gets copied from one place to somewhere else
> where it might not be appropriate.
Hi Bjorn,
	"All the users of an interface should use the same locking scheme", a really
good design pattern to follow. It's so easy for everybody to remove the __init
modifier without noticing the design limitation.
	--Gerry
