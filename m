Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab0KAVcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:32:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47229 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab0KAVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:32:32 -0400
Date: Mon, 1 Nov 2010 21:32:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andy Isaacson <adi@hexapodia.org>
Cc: srajiv@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.37-rc1 REGRESSION] suspend fails on x200 (was Re: [PATCH]
	tpm: Autodetect itpm devices)
Message-ID: <20101101213224.GA28746@srcf.ucam.org>
References: <1287697360-31273-1-git-send-email-mjg@redhat.com> <20101101211948.GA19250@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101101211948.GA19250@hexapodia.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 02:19:48PM -0700, Andy Isaacson wrote:

> I suspect that it would have failed previously if I'd forced the module
> to load, but since tpm_tis now loads automatically as of 2.6.37-rc1, I
> have to "rmmod tpm_tis" for suspend to work.

Hm. That's what this patch was intended to fix. Can you check that the 
tree you're using has it merged? The autoloading comes from the fix to 
the pnp code to use _CID even if _HID is malformed, so now we have a pnp 
device when we previously didn't.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
