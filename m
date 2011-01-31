Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab1AaXnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:43:47 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:48587 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081Ab1AaXnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:43:46 -0500
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
In-Reply-To: <201102010010.46096.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue, 1 Feb 2011 00:10:45 +0100")
Organization: Texas Instruments, Inc.
References: <201101300107.19389.rjw@sisk.pl>
	<20110131225902.GD27856@angua.secretlab.ca>
	<201102010010.46096.rjw@sisk.pl>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
Date: Mon, 31 Jan 2011 15:43:41 -0800
Message-ID: <871v3s3ahe.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

>> Also, what is the use case for having 2 sets of power_domain ops?  My
>> gut tells me that you'd only want to do post ops on the
>> {freeze,suspend,poweroff} path and pre ops on the {resume,thaw,restore}
>> path.  It seems overly engineered to me, but I may be missing
>> something fundamental.
>
> Well, that's a part of the RFC, actually. :-)
>
> For the subsystems I've worked with (PCI, ACPI, PNP to some extent) one set
> would be sufficient, but I don't know of every possible use case.

For the on-chip SoC devices we're managing with OMAP, we're currently
only using one set: post ops on [runtime_]suspend and pre ops on
[runtime_]resume.

However, I could imagine (at least conceptually) using the pre ops on
suspend to do some constraints checking and/or possibly some
management/notification of dependent devices.  Another possiblity
(although possibly racy) would be using the pre ops on suspend to
initiate some high-latency operations.

I guess the main problem with two sets is wasted space.  e.g, if I move
OMAP to this (already hacking on it) there will be only 2 functions used
in post ops: [runtime_]suspend() and 2 used in pre ops [runtime_]_resume().

Kevin

