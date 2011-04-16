Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760452Ab1DPWYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 18:24:33 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:51052 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759268Ab1DPWYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 18:24:16 -0400
Subject: Re: [RFC][PATCH] PM: Make power domain callbacks take precedence
 over subsystem ones
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <201104130205.26988.rjw@sisk.pl>
References: <201104130205.26988.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Organization: Texas Instruments, Inc.
Date: Sat, 16 Apr 2011 10:17:51 -0700
Message-ID: <1302974271.2719.33.camel@vence>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 02:05 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Change the PM core's behavior related to power domains in such a way
> that, if a power domain is defined for a given device, its callbacks
> will be executed instead of and not in addition to the device
> subsystem's PM callbacks.
> 
> The idea behind the initial implementation of power domains handling
> by the PM core was that power domain callbacks would be executed in
> addition to subsystem callbacks, so that it would be possible to
> extend the subsystem callbacks by using power domains.  It turns out,
> however, that this wouldn't be really convenient in some important
> situations.
> 
> For example, there are systems in which power can only be removed
> from entire power domains.  On those systems it is not desirable to
> execute device drivers' PM callbacks until it is known that power is
> going to be removed from the devices in question, which means that
> they should be executed by power domain callbacks rather then by
> subsystem (e.g. bus type) PM callbacks, because subsystems generally
> have no information about what devices belong to which power domain.
> Thus, for instance, if the bus type in question is the platform bus
> type, its PM callbacks generally should not be called in addition to
> power domain callbacks, because they run device drivers' callbacks
> unconditionally if defined.
> 
> While in principle the default subsystem PM callbacks, or a subset of
> them, may be replaced with different functions, it doesn't seem
> correct to do so, because that would change the subsystem's behavior
> with respect to all devices in the system, regardless of whether or
> not they belong to any power domains.  Thus, the only remaining
> option is to make power domain callbacks take precedence over
> subsystem callbacks.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Leaving the issue of to (re)name this field aside:

Acked-by: Kevin Hilman <khilman@ti.com>


