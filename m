Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435Ab0GOTDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:03:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50106 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934406Ab0GOTDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:03:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Rg6nStpeM42ArY4ovlhhFyKmQqkKeMsYI37O4zd2IdWQjUzSh3eZSCyP7U9D+pqc3c
         +jZXhRPmT0SWTcM2bWbU4hDiBBJdiTC6BsWUu37/0yvn+SfHjqs6+k4TDL27dm8ikNqf
         4NQpjC/yT6AYMlWbsouvPU3lOCLkgml163Tjo=
Date: Thu, 15 Jul 2010 22:03:05 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/25] block: Convert pci_table entries to PCI_VDEVICE
 (if PCI_ANY_ID is used)
Message-ID: <20100715185904.GA4023@x200>
References: <201007152051.18189.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007152051.18189.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 08:51:17PM +0200, Peter Huewe wrote:
> This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
> .subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
> PCI_VDEVICE macro, and thus improves readability.

Well, it doesn't improve readability, and ## usage prevents grepping and
long term plan to switch to numbers instead of PCI_VENDOR_ID_*,
but whatever.

> -	{ PCI_VENDOR_ID_PROMISE, 0x8000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
> -	{ PCI_VENDOR_ID_PROMISE, 0x8002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
> +	{ PCI_VDEVICE(PROMISE, 0x8000), },
> +	{ PCI_VDEVICE(PROMISE, 0x8002), },
