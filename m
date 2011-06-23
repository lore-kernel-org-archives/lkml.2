Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441Ab1FWAet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 20:34:49 -0400
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:56610 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757878Ab1FWAes convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 20:34:48 -0400
MIME-Version: 1.0
In-Reply-To: <1308736219-19975-1-git-send-email-alexander.stein@systec-electronic.com>
References: <1308736219-19975-1-git-send-email-alexander.stein@systec-electronic.com>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 22 Jun 2011 17:34:27 -0700
X-Google-Sender-Auth: 9nti4wgp6DZvItEODmQzvBvt8Jg
Message-ID: <BANLkTim+2Vs7nZqgDnEes5-+CZmuK7_RhA@mail.gmail.com>
Subject: Re: [PATCH] pch_uart: Add MSI support
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 2:50 AM, Alexander Stein
<alexander.stein@systec-electronic.com> wrote:
> +       if (priv->use_msi)
> +               pci_disable_msi(pdev);

Trivial nit: pci_disable_msi() is safe even if you didn't enable msi.
So you can drop the use_msi flag (the PCI layer has dev->msi_enabled
internally to track this), and just always call pci_disable_msi().

 - R.
