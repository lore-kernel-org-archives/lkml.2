Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854Ab2KAJi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 05:38:29 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36713 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887Ab2KAJi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 05:38:27 -0400
Message-ID: <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Oliver Neukum <oneukum@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Date: Thu, 01 Nov 2012 09:38:23 +0000
In-Reply-To: <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	  <2548314.3caaFsMVg6@linux-lqwf.site> <50919EED.3020601@genband.com>
	  <36538307.gzWq1oO7Kg@linux-lqwf.site>
	 <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com>
	 <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-01 at 10:20 +0100, Jiri Kosina wrote:
> On Thu, 1 Nov 2012, James Bottomley wrote:
> 
> > The point I'm making is that given that the majority of exploits will 
> > already be able to execute arbitrary code in-kernel, there's not much 
> > point trying to consider features like this as attacker prevention.  We 
> > should really be focusing on discussing why we'd want to prevent a 
> > legitimate local root from writing to the suspend partition in a secure 
> > boot environment.
> 
> Well, this is being repeated over and over again when talking about secure 
> boot, right?
> 
> My understanding is that we are not trying to protect against root 
> exploiting the kernel. We are trying to protect against root tampering 
> with the kernel code and data through legitimate use of kernel-provided 
> facilitiies (/dev/mem, ioperm, reprogramming devices to DMA to arbitrary 
> memory locations, resuming from hibernation image that has been tampered 
> with, etc).
> 
> Or perhaps I just misunderstood the point you were trying to make?

I'm actually just struggling to understand the use case for these more
esoteric protections.

So the assumption is malice on the part of a legitimate local root?  I
just don't see what such a user would gain by compromising resume in
this way (given that their scope for damage in the rest of the system
and data is huge) and I don't really see why a non-malicious local root
would be interested.  A legitimate local root entails quite a measure of
trust, so what I don't really see is the use case for investing all that
trust in someone but not trusting them with the boot system.  In a
proper capability separated limited trust environment, you simply don't
allow less trusted users raw access to all or some devices and that
solves the problem far more simply.

James


