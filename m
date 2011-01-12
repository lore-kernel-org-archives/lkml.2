Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab1ALS20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 13:28:26 -0500
Received: from relais.videotron.ca ([24.201.245.36]:58391 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1ALS2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 13:28:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 12 Jan 2011 13:28:23 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Dave Martin <dave.martin@linaro.org>
Cc: Alexander Holler <holler@ahsoftware.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM: relocation out of range (when loading a module)
In-reply-to: <AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1101121314470.25498@xanadu.home>
References: <4D2B4CE4.9080309@ahsoftware.de>
 <alpine.LFD.2.00.1101101722470.9794@xanadu.home>
 <4D2BFA08.5030104@ahsoftware.de>
 <AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com>
 <20110111155930.GH11039@n2100.arm.linux.org.uk>
 <4D2D1942.4050905@ahsoftware.de>
 <AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011, Dave Martin wrote:

> In general, do we expect always to be able to avoid the situation
> where branches in the kernel may need to cover too large a range ...
> and is there any strategy for working aroung it?

Normally we try to keep the code close together.  And at least for the 
.text section, the linker is able to insert indirect branch veneers when 
the range is too large.  But in the case of modules, it's the in-kernel 
code that perform the final symbol relocation.

> If we have problems branching from the modules area into vmlinux, we
> could possibly build modules with -fPIC : this would remove the
> restriction on branch range, though there would also be some
> performance impact for the modules...

If we really needed to do such thing, that would be even better to 
simply have the kernel create those indirect veneers dynamically.  And 
in fact, Russell had that working and he posted the corresponding patch 
many years ago, but the module placement was made so that the indirect 
branches were unnecessary.

Even now, it's probably a better idea to rework the section layout and 
preserve the ability to perform direct branches into the kernel from 
modules as much as possible.


Nicolas
