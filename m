Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab1EQCKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:10:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45380 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab1EQCKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:10:45 -0400
Date: Tue, 17 May 2011 03:10:06 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] x86, head_32/64.S: Enable SMEP
Message-ID: <20110517021006.GA6732@srcf.ucam.org>
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com>
 <1305581685-5144-4-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305581685-5144-4-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 02:34:44PM -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Enable newly documented SMEP (Supervisor Mode Execution Protection) CPU
> feature in kernel.
> 
> SMEP prevents the CPU in kernel-mode to jump to an executable page that does
> not have the kernel/system flag set in the pte. This prevents the kernel
> from executing user-space code accidentally or maliciously, so it for example
> prevents kernel exploits from jumping to specially prepared user-mode shell
> code. The violation will cause page fault #PF and will have error code
> identical to XD violation.

Are EFI runtime service pages currently set up appropriately?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
