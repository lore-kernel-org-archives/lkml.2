Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab2IDVk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:40:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58465 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2IDVkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:40:24 -0400
Date: Tue, 4 Sep 2012 22:40:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
Message-ID: <20120904214015.GA31325@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-8-git-send-email-mjg@redhat.com>
 <87txvdzgur.fsf@xmission.com>
 <20120904202205.GA28903@srcf.ucam.org>
 <87r4qhwkx9.fsf@xmission.com>
 <20120904223957.50f6a3b9@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904223957.50f6a3b9@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 10:39:57PM +0100, Alan Cox wrote:
> > > Well, given that approximately everyone will be booting under EFI within 
> > > 18 months, treating it as a niche case seems a little short sighted.
> 
> Actually the majority of Linux devices are not PCs 8)

ARM's going UEFI as well...

> I think it needs to be defined in terms of what the capability is
> supposed to guarantee. I have a feeling Matthew has a pretty clear idea
> about that in his head so can nail it fairly precisely ?

In the absence of this capability, all users (including root) should be 
unable to cause untrusted code to be executed in ring 0. This requires 
some straightforward and obvious conditions like "The user must not be 
able to load untrusted modules", but also conditions like "The user must 
not be able to cause devices to DMA over the kernel". "The user must not 
be able to kexec into an untrusted kernel" is at the more obvious end of 
the scale. This is obviously dependent upon there being some mechanism 
for ensuring that the initial kernel is trusted in the first place, 
which is where the firmware security comes in.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
