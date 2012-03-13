Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab2CMDsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 23:48:03 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60488 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759579Ab2CMDsA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 23:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <1331488109-13466-4-git-send-email-jiang.liu@huawei.com>
References: <1331488109-13466-1-git-send-email-jiang.liu@huawei.com> <1331488109-13466-4-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 12 Mar 2012 21:47:38 -0600
Message-ID: <CAErSpo4iDkWuD2XP2RH9e0MDXrJ1O0F=5tdBbzird7tBtEfAfA@mail.gmail.com>
Subject: Re: [PATCH 3/5] Fix an access-after-free issue in function pci_stop_and_remove_bus()
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jiang Liu <jiang.liu@huawei.com>, Ashok Raj <ashok.raj@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chenkeping@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 11:48 AM, Jiang Liu <liuj97@gmail.com> wrote:
> If pci_stop_and_remove_bus() is called to remove a pci root bus,
> the host_bridge structure may have already been freed after returning
> from pci_remove_bus(), so don't access the structure any more.

pci_stop_and_remove_bus() hasn't been merged yet, so any fixes should
be incorporated into Yinghai's patch that adds it.

> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  drivers/pci/remove.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 75b0092..25f368e 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -194,9 +194,6 @@ void pci_stop_and_remove_bus(struct pci_bus *bus)
>
>        pci_remove_bus(bus);
>
> -       if (host_bridge)
> -               host_bridge->bus = NULL;
> -
>        if (pci_bridge)
>                pci_bridge->subordinate = NULL;
>  }
> --
> 1.7.5.4
>
