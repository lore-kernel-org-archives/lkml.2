Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2DQLII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:08:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45599 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2DQLIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:08:06 -0400
Message-ID: <4F8D4EAC.1010301@mvista.com>
Date: Tue, 17 Apr 2012 15:06:20 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Thang Q. Nguyen" <tqnguyen@apm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jeff Garzik <jgarzik@pobox.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Phong Vo <pvo@apm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/7] Add support hardreset
References: <1334652193-10487-1-git-send-email-tqnguyen@apm.com>
In-Reply-To: <1334652193-10487-1-git-send-email-tqnguyen@apm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 17-04-2012 12:43, Thang Q. Nguyen wrote:

>   The hardreset operation is currently not supported. This causes sometime the SATA driver does cause kernel crash because of none-determined state.a This patch will fix the issue.

> Signed-off-by: Thang Q. Nguyen<tqnguyen@apm.com>
> ---
>   drivers/ata/sata_dwc_460ex.c |   24 +++++++++++++++++++++++-
>   1 files changed, 23 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
> index 69f7cde..ae13ef1 100644
> --- a/drivers/ata/sata_dwc_460ex.c
> +++ b/drivers/ata/sata_dwc_460ex.c
> @@ -1581,10 +1581,31 @@ static void sata_dwc_qc_prep(struct ata_queued_cmd *qc)
>
>   static void sata_dwc_error_handler(struct ata_port *ap)
>   {
> -	ap->link.flags |= ATA_LFLAG_NO_HRST;
>   	ata_sff_error_handler(ap);
>   }

    Could eliminate this, switching to the default implementation...

MBR, Sergei
