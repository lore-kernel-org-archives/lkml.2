Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1B1PP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:15:26 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43256 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab1B1PPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:15:25 -0500
Date: Mon, 28 Feb 2011 15:15:16 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: [PATCH] x86: use int instead of long to set reset vector back
	to 0
Message-ID: <20110228151516.GA5662@srcf.ucam.org>
References: <1297139100-424-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297139100-424-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 11:25:00PM -0500, Don Zickus wrote:
> A customer of ours, complained that when setting the reset vector
> back to 0, it trashed other data and hung their box.  They noticed
> when only 4 bytes were set to 0 instead of 8, everything worked
> correctly.

We're supposed to be resetting trampoline_phys_low and 
trampoline_phys_high here, which are two 16-bit values. Writing 64 bits 
is definitely going to overwrite space that we're not supposed to be 
touching.

> -	*((volatile long *)phys_to_virt(apic->trampoline_phys_low)) = 0;
> +	*((volatile int *)phys_to_virt(apic->trampoline_phys_low)) = 0;

I'd suggest either using u32 here, or alternatively make it more obvious 
what's going on and set trampoline_phys_low and trampoline_phys_high 
(which are both 16 bit) independently.

Ingo? Looks like you touched this last, but it seems that the bug was 
there already.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
