Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab2DNQAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:00:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58137 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2DNQAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:00:12 -0400
Date: Sat, 14 Apr 2012 17:02:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andy Whitcroft <apw@canonical.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>
Subject: Re: [PATCH 2/2] ata_piix: defer disks to the Hyper-V drivers by
 default
Message-ID: <20120414170223.24f6ea31@pyramind.ukuu.org.uk>
In-Reply-To: <1334418796-11473-3-git-send-email-apw@canonical.com>
References: <4F87351E.9040905@pobox.com>
	<1334418796-11473-1-git-send-email-apw@canonical.com>
	<1334418796-11473-3-git-send-email-apw@canonical.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> +#ifdef CONFIG_X86
> +	/* On Hyper-V hypervisors the disks are exposed on both the emulated
> +	 * SATA controller and on the paravirtualised drivers.  The CD/DVD
> +	 * devices are only exposed on the emulated controller.  Request we
> +	 * ignore ATA devices on this host.
> +	 */
> +	if (prefer_ms_hyperv && x86_hyper == &x86_hyper_ms_hyperv) {
> +		host->flags |= ATA_HOST_IGNORE_ATA;
> +		dev_info(&pdev->dev, "Hyper-V hypervisor detected, ignoring ATA disks\n");
> +	}
> +#endif

Does hyper-v not set its own unique and identifable pci
subvendor/subdevice ?

Alan
