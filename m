Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab2BAV0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:26:38 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52929 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab2BAV0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:26:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120201190940.GC20358@kroah.com>
References: <1328121545-21955-1-git-send-email-grant.likely@secretlab.ca> <20120201190940.GC20358@kroah.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 1 Feb 2012 14:26:14 -0700
X-Google-Sender-Auth: Tm3g5wdI7mvNzC8rwmYRGsLenzQ
Message-ID: <CACxGe6semcPXkGfEN76DezbC-sAgkczjofbjvbexM8g_8gPdBw@mail.gmail.com>
Subject: Re: [PATCH] drivercore: Output common devicetree information in uevent
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Tobias Klauser <tklauser@distanz.ch>,
        Frederic Lambert <frdrc66@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@sirena.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 12:09 PM, Greg Kroah-Hartman <greg@kroah.com> wrote:
> On Wed, Feb 01, 2012 at 11:39:04AM -0700, Grant Likely wrote:
>> When userspace needs to find a specific device, it currently isn't easy to
>> resolve a /sys/devices/ path from a specific device tree node.  Nor is it
>> easy to obtain the compatible list for devices.
>>
>> This patch generalizes the code that inserts OF_* values into the uevent
>> device attribute so that any device that is attached to an OF node will
>> have that information exported to userspace.  Without this patch only
>> platform devices and some powerpc-specific busses have access to this
>> data.
>>
>> The original function also creates a MODALIAS property for the compatible
>> list, but that code has not been generalized into the common case because
>> it has the potential to break module loading on a lot of bus types.  Bus
>> types are still responsible for their own MODALIAS properties.
>
> So you are only adding new properties to be exported, not removing any
> from any existing devices, right?
>
> If so, I have no objection to this at all, if you want to take this
> through your tree for 3.4, please feel free to add:
>
>        Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Or I can take it through my driver-core tree, which ever is easiest for
> you.

I'll take it via the devicetree branch.  Thanks.

g.
