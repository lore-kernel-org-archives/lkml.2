Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933818Ab1DNSUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:20:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42363 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab1DNSUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qhEF+w8JpiViZUO1dXlIBSt46sjCg72pcICN0fZurFLLUMOXOF0ONtQKhgjd/k4hMA
         ezbk5/3yUqchGiFJrosFEijSKoEgBxuMqz4jpxsW3QybNKE6u3/lekBZXC6VtqF8rVRm
         YGEDcgcuyD9/EpmnC31p7GaU6kGSLBzaVkccE=
MIME-Version: 1.0
In-Reply-To: <201104130205.26988.rjw@sisk.pl>
References: <201104130205.26988.rjw@sisk.pl>
Date: Fri, 15 Apr 2011 03:20:42 +0900
Message-ID: <BANLkTimQ6kX41-53Dw2RqEVyYzbT2qbz9Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] PM: Make power domain callbacks take precedence over
 subsystem ones
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Wed, Apr 13, 2011 at 9:05 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Change the PM core's behavior related to power domains in such a way
> that, if a power domain is defined for a given device, its callbacks
> will be executed instead of and not in addition to the device
> subsystem's PM callbacks.

Thanks for your work on this! I'm very happy to see a more fine
grained interface for SoC specific code compared to the weak symbols
and other coarse grained alternatives for the platform bus.

My only thought on this is if we really want to limit ourselves to
only control power domains using these callbacks. I can imagine that
some SoCs want to do other non-power domain specific operations with
these callbacks, and if so, perhaps using the term power domain as
name of the pointer in struct device would be somewhat odd. OTOH, I
really dislike naming discussions in general and I can't really think
of any good names. So it all looks more like a set of system specific
PM override hooks.

Or is there something that is really power domain specific with these hooks?

Thanks,

/ magnus
