Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab2JWQFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:05:07 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:17622 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab2JWQFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:05:05 -0400
From: Randy Wright <rwright@filesys1.fc.hp.com>
Message-Id: <201210231605.q9NG51KW022791@filesys1.fc.hp.com>
Subject: Re: [PATCH RFC] function probe_roms accessing improper addresses
To: mjg@redhat.com (Matthew Garrett)
Date: Tue, 23 Oct 2012 10:05:01 -0600 (MDT)
Cc: rwright@hp.com, linux-kernel@vger.kernel.org, tmac@hp.com, hpa@zytor.com,
        mjg59@srcf.ucam.org
Reply-To: rwright@hp.com
In-Reply-To: <20121019153015.GD28212@srcf.ucam.org> from "Matthew Garrett" at Oct 19, 2012 04:30:15 pm
Organization: Hewlett-Packard/Mission Critical Open Source Development Lab
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,
 
You made some interesting suggestions:

> 1) Declare that any x86 hardware supported by Linux *must* support 
> probing in this address region

On the first: one way to be compliant with such a requirement would be 
to design systems that implement softfail in this particular region.   
What about a system that hardfails, but on which the resulting machine
check can be handled by the kernel machine check handler?  Would
appropriate re-ordering of the kernel initialization code to support
such systems be acceptable?

Also, let me mention a possible amendment to your first idea: what if
the mandate that probing be supported were qualified by some attribute
that could be indicated in the UEFI environment?  For example: instead
of just a hole in the UEFI memory map, what if this range was
specifically present and typed as EfiUnusableMemory?  Another idea for
UEFI systems - but one requiring a UEFI specification change - might be
adding a UEFI variable that if present, indicates any area not
explicitly included and typed in the UEFI memory map (including the
legacy adapter region) must be explicitly avoided by an OS.

> 2) Don't call probe_roms() by default, but leave it up to the graphics 
> drivers. If they can get the rom by any other means then don't call it.

One the second idea: there are a quite a lot of video drivers in the kernel
source tree.  Do you have a suggestion for how to evaluate which ones 
rely on the setup performed by probe_roms?

-- 
Randy Wright            Hewlett-Packard Company
Phone: (970) 898-0998   Mail: rwright@hp.com
