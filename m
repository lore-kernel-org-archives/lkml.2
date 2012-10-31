Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826Ab2JaS4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:56:49 -0400
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:53138 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759729Ab2JaS4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:56:45 -0400
Message-ID: <5091746B.3040405@emulex.com>
Date: Wed, 31 Oct 2012 14:56:43 -0400
From: James Smart <James.Smart@emulex.com>
Reply-To: <James.Smart@emulex.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [patch 09/10] lpfc: use scsi_host_alloc_node
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com> <1351628084-29358-12-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1351628084-29358-12-git-send-email-jmoyer@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Jeff.

-- james s


Acked-By: James Smart  <james.smart@emulex.com>


On 10/30/2012 4:14 PM, Jeff Moyer wrote:
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>   drivers/scsi/lpfc/lpfc_init.c |   10 ++++++----
>   1 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 7dc4218..65956d3 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -3051,11 +3051,13 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
>   	int error = 0;
>   
>   	if (dev != &phba->pcidev->dev)
> -		shost = scsi_host_alloc(&lpfc_vport_template,
> -					sizeof(struct lpfc_vport));
> +		shost = scsi_host_alloc_node(&lpfc_vport_template,
> +					     sizeof(struct lpfc_vport),
> +					     dev_to_node(&phba->pcidev->dev));
>   	else
> -		shost = scsi_host_alloc(&lpfc_template,
> -					sizeof(struct lpfc_vport));
> +		shost = scsi_host_alloc_node(&lpfc_template,
> +					     sizeof(struct lpfc_vport),
> +					     dev_to_node(&phba->pcidev->dev));
>   	if (!shost)
>   		goto out;
>   

