Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1BADTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 22:19:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42279 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1BADTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 22:19:05 -0500
MIME-Version: 1.0
In-Reply-To: <871v3s3ahe.fsf@ti.com>
References: <201101300107.19389.rjw@sisk.pl> <20110131225902.GD27856@angua.secretlab.ca>
 <201102010010.46096.rjw@sisk.pl> <871v3s3ahe.fsf@ti.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 31 Jan 2011 20:18:44 -0700
X-Google-Sender-Auth: A9FFOdAvCIo7AIJpnAcv2PwBFRU
Message-ID: <AANLkTinEsUOZQURXOfAVoTU5=k0mi8PC0_Gte6gACDFj@mail.gmail.com>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
To: Kevin Hilman <khilman@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 4:43 PM, Kevin Hilman <khilman@ti.com> wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>
>>> Also, what is the use case for having 2 sets of power_domain ops?  My
>>> gut tells me that you'd only want to do post ops on the
>>> {freeze,suspend,poweroff} path and pre ops on the {resume,thaw,restore}
>>> path.  It seems overly engineered to me, but I may be missing
>>> something fundamental.
>>
>> Well, that's a part of the RFC, actually. :-)
>>
>> For the subsystems I've worked with (PCI, ACPI, PNP to some extent) one set
>> would be sufficient, but I don't know of every possible use case.
>
> For the on-chip SoC devices we're managing with OMAP, we're currently
> only using one set: post ops on [runtime_]suspend and pre ops on
> [runtime_]resume.
>
> However, I could imagine (at least conceptually) using the pre ops on
> suspend to do some constraints checking and/or possibly some
> management/notification of dependent devices.  Another possiblity
> (although possibly racy) would be using the pre ops on suspend to
> initiate some high-latency operations.
>
> I guess the main problem with two sets is wasted space.  e.g, if I move
> OMAP to this (already hacking on it) there will be only 2 functions used
> in post ops: [runtime_]suspend() and 2 used in pre ops [runtime_]_resume().

There's a conceptual load added to the (human) reader too.  Every
additional hook point is an additional piece other engineers need to
fit into their mental model.  I'm resistant to having the two sets of
ops without a definite use case for it when conceptually I can only
imagine a need for one set.

g.
