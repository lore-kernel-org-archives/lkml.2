Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab0HCPp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:45:56 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:56670 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757031Ab0HCPpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:45:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qCVAulHcaQ4JIQZ/qZh0guNPWmtDE+63VOEclLaCSLoj+OLbNbSFtevMc20LkfBymZN47s5J9yjxk+Yxc/3OWssYQPMHtDveWPIbxO9OjNLh02sKZ0KYdbTuwgHG8zcP;
Date: Tue, 3 Aug 2010 08:45:17 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] x86: intel_ips: do not use PCI resources before
 pci_enable_device()
Message-ID: <20100803084517.4e4cafc9@virtuousgeek.org>
In-Reply-To: <1280850257-6169-1-git-send-email-segooon@gmail.com>
References: <1280850257-6169-1-git-send-email-segooon@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Aug 2010 19:44:16 +0400
Kulikov Vasiliy <segooon@gmail.com> wrote:

> IRQ and resource[] may not have correct values until
> after PCI hotplug setup occurs at pci_enable_device() time.
> 
> The semantic match that finds this problem is as follows:
> 
> // <smpl>
> @@
> identifier x;
> identifier request ~= "pci_request.*|pci_resource.*";
> @@
> 
> (
> * x->irq
> |
> * x->resource
> |
> * request(x, ...)
> )
>  ...
> *pci_enable_device(x)
> // </smpl>
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/platform/x86/intel_ips.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)

Yep, thanks.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
