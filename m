Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1FIOrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:47:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36607 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1FIOrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:47:46 -0400
Date: Thu, 9 Jun 2011 15:47:36 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, pjones@redhat.com
Subject: Re: [PATCH] x86: CONFIG_EFI should select CONFIG_RELOCATABLE
Message-ID: <20110609144736.GA27953@srcf.ucam.org>
References: <1307629964-31658-1-git-send-email-mjg@redhat.com>
 <4DF0DAAB.7010005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF0DAAB.7010005@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 07:37:31AM -0700, H. Peter Anvin wrote:
> On 06/09/2011 07:32 AM, Matthew Garrett wrote:
> >  config EFI
> >  	bool "EFI runtime service support"
> >  	depends on ACPI
> > +	select RELOCATABLE
> >  	---help---
> >  	  This enables the kernel to use EFI runtime services that are
> >  	  available (such as the EFI variable services).
> 
> Can we make this a depends on instead of select?

CONFIG_RELOCATABLE has no dependencies so select should be safe, and 
depends means CONFIG_EFI vanishes until you turn on something that seems 
entirely unrelated. I've no problem with it being depends, but this 
seems friendlier.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
