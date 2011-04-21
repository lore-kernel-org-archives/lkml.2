Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab1DUXQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 19:16:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45408 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab1DUXQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 19:16:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pozKBn7pbYlHMPr+PvwYFVeKERKt2KoJb+jVxiC47z+Pf3PmlZvd4m+0po1e5gMaIP
         swzl7B2uxI+7nli3iBa0bwT0ttKOmrpiIn10qYrizgZreRzNFqoF6x4494Wval4PUNm8
         cYxoBBLr/4l0BCOvUZeCHWQ5q7YM/4OuVfDqU=
MIME-Version: 1.0
In-Reply-To: <20110304215226.7617.5852.stgit@s20.home>
References: <20110304214837.7617.46438.stgit@s20.home>
	<20110304215226.7617.5852.stgit@s20.home>
Date: Thu, 21 Apr 2011 16:16:47 -0700
X-Google-Sender-Auth: WPcputT-PPdZBsn1RaijYyRwDNw
Message-ID: <BANLkTinYLcgh=Q2ODv9PraDdTQJkf4B2qA@mail.gmail.com>
Subject: Re: [RESEND PATCH v2 2/2] intel-iommu: Fix get_domain_for_dev() error path
From: Yinghai Lu <yinghai@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        ddutile@redhat.com, chrisw@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 1:52 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> If we run out of domain_ids and fail iommu_attach_domain(), we
> fall into domain_exit() without having setup enough of the
> domain structure for this to do anything useful.  In fact, it
> typically runs off into the weeds walking the bogus domain->devices
> list.  Just free the domain.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Acked-by: Donald Dutile <ddutile@redhat.com>
> ---
>
>  drivers/pci/intel-iommu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index c58dbd7..4a66bea 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -1835,7 +1835,7 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
>
>        ret = iommu_attach_domain(domain, iommu);
>        if (ret) {
> -               domain_exit(domain);
> +               free_domain_mem(domain);
>                goto error;
>        }
>
>

can you fix another path like David pointed out last year?

https://patchwork.kernel.org/patch/91732/

Thanks

Yinghai
