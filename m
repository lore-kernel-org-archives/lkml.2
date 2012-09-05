Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab2IEC3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 22:29:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34235 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2IEC3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 22:29:38 -0400
Date: Wed, 5 Sep 2012 03:29:32 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Don Dutile <ddutile@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org,
        bhelgaas@google.com
Subject: Re: [PATCH V3 3/4] PCI: Add support for non-BAR ROMs
Message-ID: <20120905022932.GA4087@srcf.ucam.org>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
 <1345739803-21017-4-git-send-email-mjg@redhat.com>
 <5046B688.1070902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5046B688.1070902@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 10:18:48PM -0400, Don Dutile wrote:
> >  	/*
> >+	 * Some devices may provide ROMs via a source other than the BAR
> >+	 */
> >+	if (pdev->rom&&  pdev->romlen) {
> >+		*size = pdev->romlen;
> >+		return phys_to_virt((phys_addr_t)pdev->rom);
>                        ^^^^^
>                          ioremap_nocache() ? ... or is caching rom ok?

If it's appearing through this pathway then it's not actually in ROM, 
the platform has pulled it out of somewhere else.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
