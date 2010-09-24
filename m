Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0IXO5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 10:57:17 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:36874 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab0IXO5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 10:57:16 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: Dynamic Debug module.ddebug fake param enhancements V4
Date: Fri, 24 Sep 2010 08:56:16 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, jbaron@redhat.com
References: <20100920184441.GA2915@redhat.com> <1285331311-21753-1-git-send-email-trenn@suse.de>
In-Reply-To: <1285331311-21753-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009240856.17411.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 24, 2010 06:28:27 am Thomas Renninger wrote:
> The patches are intended for Greg's tree and depend on 3 other
> dynamic debug patches which already are in linux-next, but not in
> the vanilla kernel yet.
> 
> [PATCH 1/4] Dynamic Debug: Introduce global fake module param module.ddebug - V4
>      V3 -> V4: Do not put that large arrays on the stack, make one func __init
> 
> [PATCH 2/4] PNP: Compile all pnp built-in stuff in one module namespace
> [PATCH 3/4] PNP: Use dev_dbg instead of dev_printk(KERN_DEBUG.. if DYNAMIC_DEBUG is compiled in
>   -> Compile PNP subsystem in a separate pnp module namespace
> 
> [PATCH 4/4] kernel/module.c: Fix compiler warnings if debug is compiled in
>   -> minor compile fixup
> 
> Only the two PNP patches really belong together.
> If someone e.g. complains about the PNP patches, please still submit the rest.

I confess that I don't understand the objective here (only because
I haven't taken enough time to read and understand the patches).

Some examples of how you expect to use this would probably help me
understand.  And if you can compare that with the current, more
difficult way, that would be even better.

I don't know if it's relevant, but I plan to change some of the
pnp_dbg() uses to dev_printk(KERN_DEBUG).  Specifically, mainline
already logs all PCI device BARs with KERN_DEBUG, so that information
is always in dmesg.  PNP currently uses pnp_dbg() for the corresponding
ACPI device resource usage, so to get that information, I often have
to request another boot with CONFIG_PNP_DEBUG_MESSAGES=y and "pnp.debug".
I want to convert those resource messages to dev_printk(KERN_DEBUG) so
they're just always in dmesg.

Bjorn
