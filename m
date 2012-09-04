Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab2IDV1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:27:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46548 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2IDV1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:27:21 -0400
Date: Tue, 4 Sep 2012 22:27:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
Message-ID: <20120904212717.GA30899@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-8-git-send-email-mjg@redhat.com>
 <87txvdzgur.fsf@xmission.com>
 <20120904202205.GA28903@srcf.ucam.org>
 <87r4qhwkx9.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4qhwkx9.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 02:13:54PM -0700, Eric W. Biederman wrote:
> Matthew Garrett <mjg59@srcf.ucam.org> writes:
> > And 
> > secondly, there are already several non-EFI platforms that want to enact 
> > a policy preventing root from being able to arbitrarily replace the 
> > kernel. Given that people are doing this in the wild, it makes sense to 
> > move towards offering that policy in the mainline kernel.
> 
> Either this code makes sense without an appeal to EFI or this code makes
> no sense.

The driving force behind this code right now is that our choices are 
either (1) do something like this, or (2) disable kexec entirely. Like I 
said, long term we'd want to provide appropriate technical mechanisms to 
make kexec usable in a world where people want to be able to trust their 
kernel, and we have people working on that. But that being our 
motivation for the implementation doesn't mean that other parties won't 
have uses for it, and I'd like to find a solution that satisfies them as 
well.

> It is fine for jumping through the EFI trusted boot hoops to be your
> motivation, but EFI policy should not be the justification for kernel
> implementation details.

Sure it is. The kernel exists to provide the functionality that people 
require, and UEFI imposes that requirement on the people. It's like 
saying gcc policy shouldn't be the justification for kernel 
implementation details. We don't control the gcc developers, but we have 
to consume what they provide us with.

> So please rework this to come from an angle that makes sense all by
> itself.

I'm afraid I have no idea what you're asking for here. Some vendors want 
to be able to ensure that kexec is only used to load trusted code. Right 
now there's no mechanism for ensuring that, so why not at least provide 
a mechanism for them to turn it off at runtime?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
