Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab1DTRGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 13:06:00 -0400
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:28920 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1DTRF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 13:05:59 -0400
X-IronPort-AV: E=Sophos;i="4.64,246,1301871600"; 
   d="scan'208";a="763113546"
MIME-Version: 1.0
X-Priority: Normal
X-Mailer: AtMail PHP 5.62
Message-ID: <20131.1303319102@jupiter.eclipse.co.uk>
To: "Rik van Riel" <riel@redhat.com>, <rwhitton@iee.org>
Reply-To: rwhitton@iee.org
Content-Type: text/plain; charset="utf-8"
X-Origin: 213.121.168.130
X-Atmail-Account: rwhitton@jupiter.eclipse.co.uk
Date: Wed, 20 Apr 2011 18:05:02 +0100
Subject: Re: Background memory scrubbing
From: Robert Whitton <rwhitton@iee.org>
Cc: <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed 20/04/11  6:45 PM , Rik van Riel <riel@redhat.com> wrote:

> On 04/20/2011 03:58 AM, Robert Whitton wrote:
> 
> > for each PFN from 256 to the highest valid PFN
> > {
> > if (pfn_valid(PFN))
> > {
> > page = pfn_to_page(PFN)
> > va = kmap(page)
> > atomic_scrub(va, PAGE_SIZE)
> > kunmap(page)
> > }
> >
> > sleep(for_a_while)
> > }
> 
> What exactly does atomic_scrub do?

atomic_scrub is part of the edac subsystem see arch/x86/include/asm/edac.h. It simply does a locked add of zero to each DWORD in the specified range.

(a shame that for 64 bit platforms it doesn't use QWORDS but that's just an optimisation)

> 
> > This code works absolutely fine up to a short distance beyond the 16MB
> boundary (specifically it seems to always fail on my hardware at PFN
> 4105). At this point despite the fact that kmap returns a valid virtual
> address (and it is the virtual address that I expect - 0xffff880001009000)
> I get the kernel oops - "unable to handle kernel paging request".
> 
> Looks like you might be making some of the kernel code that
> is running at that moment unreachable, leading to a kernel
> page fault.
> 
> ______________________________________________________________________
> This email has been scanned by the MessageLabs Email Security System.
> For more information please visit http://www.messagelabs.com/email [1] 
> ______________________________________________________________________
> 
> 
> 
> Links:
> ------
> [1]
> http://webmail.eclipse.net.uk/parse.php?redirect=http://www.messagelabs.com
> /email
> 
