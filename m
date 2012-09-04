Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab2IDUWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:22:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34508 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab2IDUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:22:08 -0400
Date: Tue, 4 Sep 2012 21:22:05 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
Message-ID: <20120904202205.GA28903@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-8-git-send-email-mjg@redhat.com>
 <87txvdzgur.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txvdzgur.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 01:13:32PM -0700, Eric W. Biederman wrote:
> 
> Matthew Garrett <mjg@redhat.com> writes:
> 
> > kexec could be used as a vector for a malicious user to use a signed kernel
> > to circumvent the secure boot trust model. In the long run we'll want to
> > support signed kexec payloads, but for the moment we should just disable
> > loading entirely in that situation.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> This makes no sense.  The naming CAP_SECURE_FIRMWARE is attrocious,
> you aren't implementing or enforcing secure firmware.

I'm certainly not attached to the name, and have no problem replacing 
it.

> You don't give any justification for this other than to support some
> silly EFI feature.  Why would anyone want this if we were not booting
> under EFI?

Well, given that approximately everyone will be booting under EFI within 
18 months, treating it as a niche case seems a little short sighted. And 
secondly, there are already several non-EFI platforms that want to enact 
a policy preventing root from being able to arbitrarily replace the 
kernel. Given that people are doing this in the wild, it makes sense to 
move towards offering that policy in the mainline kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
