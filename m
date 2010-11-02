Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0KBPUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:20:46 -0400
Received: from lechat.rtp-net.org ([88.191.19.38]:33337 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab0KBPUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:20:40 -0400
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: sowani@gmail.com
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH 2.6.36 1/1] xgifb: change obsolete pci_find_device() with pci_get_device().
Organization: RtpNet
References: <4CD02860.2020103@gmail.com>
Date: Tue, 02 Nov 2010 16:21:36 +0100
In-Reply-To: <4CD02860.2020103@gmail.com> (Atul Sowani's message of "Tue, 02
	Nov 2010 20:34:00 +0530")
Message-ID: <874obz7nun.fsf@lechat.rtp-net.org>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atul Sowani <sowani@gmail.com> writes:
Hi,

> Replaced obsolete pci_find_device() calls with pci_get_device() calls. This is
> recommended in pci.txt filei in PCI Documentation.
>
> Signed-off-by: Atul Sowani <sowani@gmail.com>
> ---
> diff -uprN a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
> --- a/drivers/staging/xgifb/XGI_main_26.c	2010-10-21 02:00:22.000000000 +0530
> +++ b/drivers/staging/xgifb/XGI_main_26.c	2010-11-01 14:25:21.032436943 +0530
> @@ -483,7 +483,7 @@ XGIfb_query_VGA_config_space(struct xgi_
>  			break;
>  		}
>
> -		pdev = pci_find_device(PCI_VENDOR_ID_SI, nbridge_id, pdev);
> +		pdev = pci_get_device(PCI_VENDOR_ID_SI, nbridge_id, pdev);
>  		if (pdev)
>  			valid_pdev = 1;

hmm... I guess that a pci_dev_put() call is lacking if it has been found.

Arnaud
