Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab2LFGTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 01:19:15 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:49013 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2LFGTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 01:19:13 -0500
Date: Thu, 6 Dec 2012 06:19:03 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Use PCI ROMs from EFI boot services
Message-ID: <20121206061903.GA3068@srcf.ucam.org>
References: <20121203200241.GG5906@thinkpad-t410>
 <CAE9FiQVdpmmExrPrLf7HYVuo0cTY9Xjn6bWzObbuSSeQ-e1PbA@mail.gmail.com>
 <20121206001819.GA30527@srcf.ucam.org>
 <50BFE50C.8030008@zytor.com>
 <CAE9FiQX+M+VynyERC0W3y8rvr1tBxWnuBqJ6E-ywC_=HvJE66g@mail.gmail.com>
 <50BFE890.5070109@zytor.com>
 <d8d553fb-1571-4fdc-833c-92b80e15bc25@email.android.com>
 <50BFEF09.9000408@zytor.com>
 <cd3b2e67-92af-494d-ba2d-4179ead6e06b@email.android.com>
 <50BFF328.5030406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BFF328.5030406@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 05:21:44PM -0800, H. Peter Anvin wrote:
> On 12/05/2012 05:13 PM, Matthew Garrett wrote:
> >Yeah, it needs to be hidden from root - but ideally we'd be passing it to the second kernel if we kexec. Alternative would be for it to be capability bounded to a trusted signed kexec binary if we implement Vivek's IMA-based approach.
> >
> 
> Either way a security flag in the type field makes sense.

I've no objection to that, although I'm not sure there's any real reason 
to expose an incomplete setup_data to userspace. Any scenario in which 
kexec can't read the full data is one where kexec won't be able to 
call sys_kexec() anyway.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
