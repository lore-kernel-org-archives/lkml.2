Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab0JOKQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 06:16:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:52928 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab0JOKQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 06:16:21 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Process to push changes to include/linux/types.h
Date: Fri, 15 Oct 2010 12:15:49 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.3-desktop; KDE/4.4.4; x86_64; ; )
Cc: Andi Kleen <andi@firstfloor.org>, Jan Engelhardt <jengelh@medozas.de>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, davem@davemloft.net
References: <1287084892.3367.18.camel@dhcp231-212.rdu.redhat.com> <878w1zc1ba.fsf@basil.nowhere.org> <20101015020134.e552d081.akpm@linux-foundation.org>
In-Reply-To: <20101015020134.e552d081.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151215.49392.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 October 2010 11:01:34 Andrew Morton wrote:
> On Fri, 15 Oct 2010 10:22:49 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Jan Engelhardt <jengelh@medozas.de> writes:
> > 
> > > I would be interested in knowing whether you - in whichever subsystems
> > > you happen to be active - would even need aligned_u64. Right now,
> > > the only users seem to be PPP and scsi_tgt besides Netfilter.
> > 
> > Using aligned_u64 is good practice to avoid problems with the 
> > 32bit/64bit compat layer. I would recommend it to anyone 
> > adding a new user space interface passing a 64bit value.
> > 
> 
> What "problems" does it prevent when used for this?

64-bit values align to 4-byte boundaries on some 32-bit architectures like x86 
and to 8-byte boundaries on 64-bit architetures.  The new __aligned_64 type 
enforces 8-byte alignment and so structs containing __aligned_64 values have 
the same alignment on 32-bit and 64-bit architectures.  No conversions are 
necessary between 32-bit user-space and a 64-bit kernel.

Andreas
