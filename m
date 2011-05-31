Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab1EaJW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:22:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:21563 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab1EaJW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:22:57 -0400
X-ExtLoop1: 1
Date: Tue, 31 May 2011 10:09:59 +0100
From: Alan Cox <alan@linux.intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH v3] 8250_pci: add -ENODEV code for Intel EG20T PCH
Message-ID: <20110531100959.011ea462@bob.linux.org.uk>
In-Reply-To: <1306808559-4246-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1306808559-4246-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> V2: Delete #ifdef CONFIG_SERIAL_PCH_UART ~ #endif
>     Use quirk table structure

I would keep the ifdef. We want to fall back and if we don't do that
then users currently using 8250 will have their system break on upgrade
which is not acceptable really.

So I'd keep with the patch below but:

> +static int pci_eg20tpch_init(struct pci_dev *dev)
> +{
#if !defined(CONFIG_SERIAL_PCH_UART) && ...
> +	return -ENODEV;
#else
	return 0;
#endif

> +}


I don't think we can avoid that one ifdef without breakage.
