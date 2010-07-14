Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0GNOgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:36:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40112 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab0GNOgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:36:38 -0400
Date: Wed, 14 Jul 2010 15:36:25 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: eusou15@yahoo.com, ibm-acpi-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, toralf.foerster@gmx.de
Subject: Re: [PATCH] Remove 9 second reboot delay on Lenovo T400/T500
Message-ID: <20100714143625.GA30721@srcf.ucam.org>
References: <4C3DCAA4.9050602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3DCAA4.9050602@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 03:33:08PM +0100, Pedro Ribeiro wrote:
>  Please consider this patch. Let me know if you would like me to change
>  anything or if you don't agree with it. It applies cleanly to 2.6.35-rc5.
> 
>  The Lenovo T400 and T500 have an annoying 9 second delay when
>  rebooting, unless reboot=pci is passed to the kernel command line.
>  This delay happens from at least kernel 2.6.20.
> 
>  Make this change permanent by hardcoding the Tx00 on the
>  arch/kernel/reboot.c pci quirks table.

There's two possibilities here:

1) Lenovo's firmware is broken and the 9-second delay is always going to 
be there. In that case we should try to use the ACPI reboot vector 
first.

2) We're doing something wrong in our shutdown sequence which then 
triggers this problem as a result.

Either way, I think this patch is wrong.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
