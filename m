Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab1AMRmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:42:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53125 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab1AMRmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:42:02 -0500
Date: Thu, 13 Jan 2011 17:41:39 +0000
From: Matthew Garrett <mjg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, horms@verge.net.au,
        nhorman@tuxdriver.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, vgoyal@redhat.com
Subject: Re: [PATCH v2][EFI] Run EFI in physical mode
Message-ID: <20110113174139.GB22823@srcf.ucam.org>
References: <F7CB3D97D99F33indou.takao@jp.fujitsu.com> <4D06E7FE.5000600@jp.fujitsu.com> <9CB9BB8ED64BAindou.takao@jp.fujitsu.com> <20110113163838.GA21289@srcf.ucam.org> <m1bp3kbu6t.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bp3kbu6t.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 09:16:26AM -0800, Eric W. Biederman wrote:
> Matthew Garrett <mjg@redhat.com> writes:
> 
> > We're seeing issues with some Dell hardware when EFI is run in physical 
> > mode - it seems that Windows uses virtual mode, so the physical path is 
> > never exercised. I'm not sure that changing the default to physical is 
> > going to be possible without compatibility issues.
> 
> The bootloaders use physical mode, and there shouldn't be a separate
> physical vs virtual mode.  It should be the same code with or without
> relocations applied.  At worst we can set virtual address to the
> physical address, on buggy boards.

Haven't we learned that failing to mimic Windows as closely as possible 
in firmware interactions is a recipe for immense disaster yet? We'll 
never successfully blacklist every broken machine.

> Honestly if the problem is the EFI code is so buggy we can't use it
> in physical mode the answer is almost certainly not to use the
> buggy EFI code.

Which would be fine, except...

> The only bits that I don't think have an alternative are the firmware
> variable accesses.   Which are a nice to have, but not a show stopper
> anywhere.

It's not typically possible to set up the bootloader without EFI 
variable acccess.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
