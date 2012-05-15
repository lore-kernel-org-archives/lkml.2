Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662Ab2EOMrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:47:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47804 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab2EOMrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:47:14 -0400
Date: Tue, 15 May 2012 13:47:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        matt.fleming@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
Message-ID: <20120515124707.GB25248@srcf.ucam.org>
References: <4FB265AB0200007800083CC5@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB265AB0200007800083CC5@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 01:18:19PM +0100, Jan Beulich wrote:

> Simply removing the #ifdef around the respective code isn't enough,
> however: The runtime code must not only be forced to be executable, it
> also must have a proper virtual address set (which on at least the
> system I'm testing on isn't the case for all necessary regions, or at
> least not as early as they're now being required).

I don't understand this. The get_time pointer won't be updated to the 
virtual function until the end of efi_enter_virtual_mode, at which point 
all runtime regions should have a virtual address mapped. We also call 
runtime_code_page_mkexec() immediately after updating that pointer, 
although maybe the order should be swapped. So I think the bug you're 
fixing is not the bug you think you're fixing...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
