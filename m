Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1KGUi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:38:27 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54344 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab1KGUi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:38:26 -0500
Date: Mon, 7 Nov 2011 20:37:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86, efi: Calling __pa() with an ioremap'd address
 is invalid
Message-ID: <20111107203752.GA27875@srcf.ucam.org>
References: <1320680088-2584-1-git-send-email-matt@console-pimps.org>
 <20111107202324.GA27515@srcf.ucam.org>
 <4EB8413D.6030500@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB8413D.6030500@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 12:36:13PM -0800, H. Peter Anvin wrote:

> Yes, I think it makes a lot of sense.  If we need to introduce new
> meta-types to deal with the fact that there are EFI types that don't map
> to E820, then so be it... and this is *exactly* why we want the EFI
> setup stub to be part of the kernel image and not off in a separate
> bootloader, requiring a stable interface...

I don't disagree, it's just going to be an absolute pain to manage that 
in a secure boot world. Looking at the code, we actually already seem to 
have decided to start just making up E820 types, so maybe we should just 
do that...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
