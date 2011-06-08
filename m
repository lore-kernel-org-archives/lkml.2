Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1FHVHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:07:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab1FHVHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:07:11 -0400
MIME-Version: 1.0
In-Reply-To: <20110608204244.GA31484@srcf.ucam.org>
References: <20110608192950.GA29235@srcf.ucam.org> <4DEFCF1A.9030400@kernel.org>
 <20110608193833.GA29855@srcf.ucam.org> <4DEFD220.5040507@kernel.org>
 <20110608195250.GB30256@srcf.ucam.org> <4DEFD58D.5060402@kernel.org>
 <20110608200903.GA30694@srcf.ucam.org> <4DEFDA4A.9080500@kernel.org>
 <20110608203037.GA31052@srcf.ucam.org> <4DEFDD69.7010000@kernel.org> <20110608204244.GA31484@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Jun 2011 14:06:21 -0700
Message-ID: <BANLkTikfbSsgGgNEQ3GVD=HOPn1Dz_xh+g@mail.gmail.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 1:42 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Jun 08, 2011 at 01:36:57PM -0700, Yinghai Lu wrote:
>
>> or just let bootloader to mark those boot services just like run-time services in e820 table or setupdata?
>
> That was my original approach, but if there's boot services code at the
> top of RAM it means that max_pfn is wrong and it's difficult to recover
> the memory.

WHO CARES if the memory is difficult to recover? Just let it be. EFI
is an abomination in the eyes of God, and we sure as hell shouldn't
bend over backwards over the stupidities in it. If it means that you
lose a meg of RAM when you use EFI, that's the least of our problems.

F*%#ing morons who thought that we wanted some kind of extensible
firmware interface. We want a *cut-down* firmware interface, not the
crazy thing that is EFI. A boot loader, not some kind of run-time
services crap. And we definitely don't want to make it any more
complex than we need to.

So just turn the EFI stuff into the memory map, and let the kernel do
as little as possible with it.

                           Linus
