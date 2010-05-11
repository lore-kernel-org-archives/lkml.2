Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab0EKRaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:30:39 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:55881 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932228Ab0EKRah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:30:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nHqhq2XoCzJcN2WoKvnQ6bsmQEKhei4Vr/Gl7xXLoDupJp40QdLd9WNq9wDfjZRTn5D68KiAn1n5vC9faoj1fyCYHc6MQiIvr00Fk6RGfhPcZ/riiaITO6FfPRCatUa4;
Date: Tue, 11 May 2010 10:29:57 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-pci@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: return correct value when writing to the "reset"
 attribute
Message-ID: <20100511102957.377cccfa@virtuousgeek.org>
In-Reply-To: <20100511094453.12485.43792.stgit@leela.lan>
References: <20100511094453.12485.43792.stgit@leela.lan>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 11:44:54 +0200
Michal Schmidt <mschmidt@redhat.com> wrote:

> A successful write() to the "reset" sysfs attribute should return the
> number of bytes written, not 0. Otherwise userspace (bash) retries the
> write over and over again.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> ---
> 
>  drivers/pci/pci-sysfs.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index fad9398..ba88a2f 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -960,7 +960,12 @@ static ssize_t reset_store(struct device *dev,
>  
>  	if (val != 1)
>  		return -EINVAL;
> -	return pci_reset_function(pdev);
> +
> +	result = pci_reset_function(pdev);
> +	if (result < 0)
> +		return result;
> +
> +	return count;
>  }
>  
>  static struct device_attribute reset_attr = __ATTR(reset, 0200, NULL, reset_store);

Applied to my linux-next branch, thanks.  I think it's probably too
late to get this into 2.6.34, but if it's affecting real users we can
try; otherwise you could get it into the stable tree.

-- 
Jesse Barnes, Intel Open Source Technology Center
