Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2IRXyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:54:50 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55146 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2IRXyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:54:47 -0400
Date: Wed, 19 Sep 2012 00:54:38 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] PCI: fix default vga ref_count
Message-ID: <20120918235438.GA13373@srcf.ucam.org>
References: <CAErSpo54VVFHj4TDA5JELW0LwFVMXjVOJywwFQ4fo4C1rX69mQ@mail.gmail.com>
 <1348011882-31452-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348011882-31452-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 04:44:42PM -0700, Yinghai Lu wrote:

>  void vga_set_default_device(struct pci_dev *pdev)
>  {
> +	if (vga_default)
> +		pci_dev_put(vga_default);
> +
> +	if (pdev)
> +		pdev = pci_dev_get(pdev);
> +
>  	vga_default = pdev;

It shouldn't happen, but do we want to check for the vga_default == pdev 
case?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
