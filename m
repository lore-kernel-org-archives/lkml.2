Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1FHTXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:23:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50342 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab1FHTXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:23:40 -0400
Date: Wed, 8 Jun 2011 20:23:21 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jim Bos <jim876@xs4all.nl>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110608192321.GA28865@srcf.ucam.org>
References: <4DECFC1C.10801@xs4all.nl>
 <4DED0394.2090000@gmail.com>
 <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com>
 <20110607014127.GA8450@srcf.ucam.org>
 <4DED8752.5070005@kernel.org>
 <4DEDEA73.7010900@gmail.com>
 <4DEE17F9.6020503@gmail.com>
 <4DEEA548.5020405@kernel.org>
 <4DEFA6E3.6090809@xs4all.nl>
 <4DEFCAE0.6050700@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEFCAE0.6050700@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 12:17:52PM -0700, Yinghai Lu wrote:
> we need to revert patch from mjg.
> 
> From 916f676f8dc016103f983c7ec54c18ecdbb6e349 Mon Sep 17 00:00:00 2001
> From: Matthew Garrett <mjg@redhat.com>
> Date: Wed, 25 May 2011 09:53:13 -0400
> Subject: [PATCH] x86, efi: Retain boot service code until after switching to
>  virtual mode

That's not a long-term option, since we have no way to distinguish 
between a machine that requires boot services code to be mapped and a 
machine that doesn't. Reverting just breaks the former set again. We 
need to ensure that the kernel isn't overlapping boot services code.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
