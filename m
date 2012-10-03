Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2JCF2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 01:28:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46167 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab2JCF2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 01:28:22 -0400
Date: Wed, 3 Oct 2012 06:28:03 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, T Makphaibulchoke <tmac@hp.com>,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        akpm@linux-foundation.org, yinghai@kernel.org, tiwai@suse.de,
        viro@zeniv.linux.org.uk, aarcange@redhat.com, tony.luck@intel.com,
        mgorman@suse.de, weiyang@linux.vnet.ibm.com,
        octavian.purdila@intel.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Fix devmem_is_allowed for below 1MB accesses for an
 efi machine
Message-ID: <20121003052803.GA27464@srcf.ucam.org>
References: <1349213536-3436-1-git-send-email-tmac@hp.com>
 <506B6191.6080605@zytor.com>
 <20121003043116.GA26241@srcf.ucam.org>
 <506BC2A0.8060500@zytor.com>
 <20121003051522.GA27113@srcf.ucam.org>
 <506BC96D.10507@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506BC96D.10507@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 11:13:17PM -0600, Thavatchai Makphaibulchoke wrote:

> Sounds like a better solution is to allow accesses to only I/O regions 
> presented in the EFI memory map for physical addresses below 1 MB.

That won't work - unfortunately we do still need the low region to be 
available for X because some platforms expect us to use int10 even on 
EFI (yes, yes, I know). Do you have a copy of the EFI memory map for a 
system that's broken with the current code?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
