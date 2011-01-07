Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab1AGW1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:27:32 -0500
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:50470 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752263Ab1AGW1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:27:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PQHBMH34pCCebTMVx0snZOUfuBtHxfPRzPyDdCF+9VDx2t2Y8qfHCOGfzu6XY+qCrB0l1zBm7dcC/Lr0RRxK2KqkhC4uQfC5YeGwbSmrWJ3XDY6tHt/BVeKblVVejr7l;
Date: Fri, 7 Jan 2011 14:27:27 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, chrisw@redhat.com,
        avi@redhat.com
Subject: Re: [PATCH] PCI: sysfs: Update ROM to include default owner write
 access
Message-ID: <20110107142727.6c59e1ce@jbarnes-desktop>
In-Reply-To: <20110105172615.20107.20267.stgit@s20.home>
References: <20110105172615.20107.20267.stgit@s20.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Jan 2011 10:26:41 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> The PCI sysfs ROM interface requires an enabling write to access
> the ROM image, but the default file mode is 0400.  The original
> proposed patch adding sysfs ROM support was a true read-only
> interface, with the enabling bit coming in as a feature request.
> I suspect it was simply an oversight that the file mode didn't
> get updated to match the API.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  drivers/pci/pci-sysfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 63d5042..8ecaac9 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -1149,7 +1149,7 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
>  		sysfs_bin_attr_init(attr);
>  		attr->size = rom_size;
>  		attr->attr.name = "rom";
> -		attr->attr.mode = S_IRUSR;
> +		attr->attr.mode = S_IRUSR | S_IWUSR;
>  		attr->read = pci_read_rom;
>  		attr->write = pci_write_rom;
>  		retval = sysfs_create_bin_file(&pdev->dev.kobj, attr);

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
