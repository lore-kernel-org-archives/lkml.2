Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1I3Hbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 03:31:55 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:1200 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1I3Hbx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:4:1>);
	Fri, 30 Sep 2011 03:31:53 -0400
Message-Id: <4E858C850200007800058A6E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 30 Sep 2011 08:31:49 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Dan Carpenter" <error27@gmail.com>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/9] xen/pciback: Do not dereference
	 psdev during printk when it is NULL.
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
 <1317325971-21603-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1317325971-21603-2-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 29.09.11 at 21:52, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> . instead use printk(.. facility.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/xen-pciback/pci_stub.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/xen/xen-pciback/pci_stub.c 
> b/drivers/xen/xen-pciback/pci_stub.c
> index aec214a..32d6891 100644
> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -514,9 +514,11 @@ static void kill_domain_by_device(struct pcistub_device 
> *psdev)
>  	int err;
>  	char nodename[PCI_NODENAME_MAX];
>  
> -	if (!psdev)
> -		dev_err(&psdev->dev->dev,
> -			"device is NULL when do AER recovery/kill_domain\n");
> +	if (!psdev) {
> +		printk(KERN_ERR DRV_NAME
> +			":device is NULL when do AER recovery/kill_domain\n");
> +		return;
> +	}

This is bogus - all callers of this function already make sure psdev is
non-NULL, so imo the check should be removed or replaced with a
BUG_ON().

Jan

>  	snprintf(nodename, PCI_NODENAME_MAX, "/local/domain/0/backend/pci/%d/0",
>  		psdev->pdev->xdev->otherend_id);
>  	nodename[strlen(nodename)] = '\0';




