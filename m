Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141Ab1D1NGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:06:08 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58986 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab1D1NGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:06:06 -0400
Date: Thu, 28 Apr 2011 14:05:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Huang Ying <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, efi: Only print warning when desc_size is smaller
 than defined one.
Message-ID: <20110428130545.GA14075@srcf.ucam.org>
References: <4DB74A50.3080804@kernel.org>
 <20110427123935.1aacd8b9@mfleming-mobl1.ger.corp.intel.com>
 <4DB850D1.30203@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB850D1.30203@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:22:25AM -0700, Yinghai Lu wrote:

> 1. bootloader aka grub.efi will convert efi memmap to e820 memmap and pass it in boot params.
>    and current grub.efi does not compare desc_size and struct size.

So we'll already have crashed and burned before we got here, and so this 
check will never fire. I sent a patch to just remove the message on the 
28th of March.

There's no way someody could ship a system with a desc_size that's 
smaller than sizeof(memdesc). It wouldn't boot anything.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
