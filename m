Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab2JHPfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:35:43 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61110 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2JHPfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:35:41 -0400
Date: Mon, 8 Oct 2012 08:35:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>,
        lkml <linux-kernel@vger.kernel.org>, jim.cromie@gmail.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        jbaron@redhat.com
Subject: Re: [bisected] stray angle bracket in dmesg
Message-ID: <20121008153536.GB17568@kroah.com>
References: <5072DD92.2000305@cwi.nl>
 <20121008141829.GA244@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121008141829.GA244@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 04:18:29PM +0200, Markus Trippelsdorf wrote:
> On 2012.10.08 at 15:05 +0100, Wouter M. Koolen wrote:
> > Hi guys,
> > 
> > After upgrading from 3.5.4 to 3.5.5 I started noticing log lines of the 
> > form (just a random sample)
> > 
> > pci_bus 0000:00: >resource 4 [io  0x0000-0x0cf7]
> > pnp 00:07: >Plug and Play ACPI device, IDs PNP0303 (active)
> > system 00:04: >[io  0x0680-0x069f] has been reserved
> > pci_root PNP0A08:00: >host bridge window [io  0x0000-0x0cf7]
> > 
> > Note the right angle bracket between the device name and the message 
> > string. These angle brackets were not there up till 3.5.4.
> > 
> > This does not happen in all dmesg lines. Only the ones that start with a 
> > device identifier.
> > 
> > I assume this angle bracket was not intentional. Otherwise please excuse 
> > the noise.
> > 
> > I noticed this because all of these lines now suddenly slip through my 
> > logcheck ignore rules.
> > 
> > Bisection points to this commit:
> > 
> > commit 3d822616ca81881d8c19d0b473e79ba241c700de
> > Author: Markus Trippelsdorf <markus@trippelsdorf.de>
> > Date:   Sat Aug 18 18:35:51 2012 -0600
> 
> This patch should be reverted for stable, since the move to ASCII SOH (
> commit 04d2c8c83d0) wasn't backported. So the fix just isn't necessary.

Ick, sorry about that, I'll go revert it for the next 3.5.y release,
thanks for letting me know.

greg k-h
