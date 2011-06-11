Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab1FKP3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 11:29:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59330 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab1FKP3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 11:29:46 -0400
Date: Sat, 11 Jun 2011 16:29:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110611152931.GA13902@srcf.ucam.org>
References: <20110607014127.GA8450@srcf.ucam.org>
 <4DED8752.5070005@kernel.org>
 <4DEDEA73.7010900@gmail.com>
 <20110610164706.GB25774@srcf.ucam.org>
 <4DF259B2.9070403@gmail.com>
 <20110610175429.GA28500@srcf.ucam.org>
 <4DF29E7E.50908@gmail.com>
 <4DF2A17E.7000103@kernel.org>
 <20110610230359.GA2084@srcf.ucam.org>
 <4DF2A81C.7000902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF2A81C.7000902@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 04:26:20PM -0700, Yinghai Lu wrote:
> On 06/10/2011 04:03 PM, Matthew Garrett wrote:
> > The medium-term fix is to ensure that the bootloaders don't put the 
> > kernel on top of boot services code. 
> 
> that is not enough, will need to make arch/x86/boot/compressed/head_64.S parse e820 table to find right decompress position.

That's fine, we can ensure we load it where there's enough space.

> > But the short-term fix here is to allocate all boot 
> > services regions that don't overlap with the kernel. That'll fix some 
> > number of machines and shouldn't break any existing ones.
> 
> that is questionable and dangerous. before SetVirtualAddressMap, some function in boot service could be called,
> those data or code for boot services could be overlapped kernel. so kernel code could be damaged by those calling.

Right now it's guaranteed that the system will crash in this situation. 
It seems reasonable to give it a fighting chance.

> also that will make our kernel code more messy.

It's code that deals with firmware, so really that's a given...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
