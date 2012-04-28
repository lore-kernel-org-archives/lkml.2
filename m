Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab2D1RW1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 13:22:27 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64560 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2D1RWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 13:22:02 -0400
MIME-Version: 1.0
In-Reply-To: <157393863283F442885425D2C454285623D5F96D@nasanexd02a.na.qualcomm.com>
References: <1335578325-21326-1-git-send-email-xiong@qca.qualcomm.com>
 <1335578325-21326-2-git-send-email-xiong@qca.qualcomm.com>
 <20120428020510.GJ14465@tux> <157393863283F442885425D2C454285623D5F96D@nasanexd02a.na.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Sat, 28 Apr 2012 10:21:40 -0700
X-Google-Sender-Auth: 1Zha8xI9FAn0xV_iLGnP4via6nU
Message-ID: <CAB=NE6VhF=nj8-n_QY339VOzQUEPZsSzsOd7Q2TwgyUywzdjNA@mail.gmail.com>
Subject: Re: [PATCH 01/10] atl1c: add workaround for issue of bit INTX-disable
 for MSI interrupt
To: "Huang, Xiong" <xiong@qca.qualcomm.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 2:53 AM, Huang, Xiong <xiong@qca.qualcomm.com> wrote:
> Thanks Luis,  just one question:
>
> I don't know which kernel version contains the updated pci/quirks.c, so,
> if I write the patch file (a 58-drivers-pci-quirks.patch) as:
>
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
>
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22))
> +       pdev->dev_flags |= PCI_DEV_FLAGS_MSI_INTX_DISABLE_BUG;
> +#endif
>
>
> It seems not good for the kernel with updated pci/quirks.c
>
> Any better suggestion ? thanks

That looks good for the backport, you would just ifdef around <
KERNEL_VERSION(3,5,0)

  Luis
