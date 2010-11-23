Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab0KWEsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 23:48:50 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:53364 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0KWEss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 23:48:48 -0500
Date: Mon, 22 Nov 2010 23:48:26 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH RESEND] tools: add power/x86/x86_energy_perf_policy to
 program MSR_IA32_ENERGY_PERF_BIAS
In-reply-to: <20101122203359.GD21836@basil.fritz.box>
Message-id: <alpine.LFD.2.00.1011222343140.19247@x980>
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
 <alpine.LFD.2.00.1009281143070.14962@localhost.localdomain>
 <alpine.LFD.2.00.1010230035360.29399@localhost.localdomain>
 <alpine.LFD.2.00.1011151103280.2939@x980> <8739r0rxlz.fsf@basil.nowhere.org>
 <alpine.LFD.2.00.1011221348200.19247@x980>
 <20101122203359.GD21836@basil.fritz.box>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010, Andi Kleen wrote:

> On Mon, Nov 22, 2010 at 03:13:24PM -0500, Len Brown wrote:
> > Per the comments from Andrew and others, the concept of a
> > "full tools build" doesn't actually exit (yet).
> > 
> > So I guess the only assurance that somebody not on x86 would run
> > make in this directory this utility lives in tools/power/x86/
> > 
> > Note that there are other utilities under tools
> > which have no Makefile at all...
> 
> I suspect this will need to be fixed at some point.
> 
> e.g. kernel rpms probably don't want to hard code all of this
> but just call some standard make file target. And the kernel
> eventually needs a make install_user or similar.

I agree, but I don't volunteer to set up such
a build system as part of this particular patch.
As I mentioned, supplying any Makefile is
a step better than some of the peers...

> > I'm not inclined to bother, as the use-case for this utility
> > is to be invoked by another program, and the options available
> 
> What other program?
> 
> I could well imagine administrators sticking this 
> into their boot.locals to set the policy they want.

right, and that would be a program.
It is unlikely that users are going to be typing this
command, except into an admin script.

> > In the highly unlikely scenario that somebody uses
> > the -r option to excerise the read-only code,
> > and simultaneously invokes and completes a cpu hot remove
> 
> FWIW there are setups where core offlining can happen
> automatically in response to an error.

Understood.  I think it is fine if this utility
simply exits if that error occurs while it is running.

(turbostat, OTOH, may be long running, and it treats
 vanishing processors as a recoverable error)

thanks,
-Len Brown, Intel Open Source Technology Center


