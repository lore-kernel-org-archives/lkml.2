Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab0LJQQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:16:50 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43692 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab0LJQQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:16:49 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v6 0/5] da850-evm: add gpio-{keys,leds} for UI and BB expanders
Organization: Deep Root Systems, LLC
References: <cover.1290635422.git.bengardiner@nanometrics.ca>
	<cover.1291931041.git.bengardiner@nanometrics.ca>
Date: Fri, 10 Dec 2010 08:16:43 -0800
In-Reply-To: <cover.1291931041.git.bengardiner@nanometrics.ca> (Ben Gardiner's
	message of "Thu, 9 Dec 2010 16:51:02 -0500")
Message-ID: <87tyild2ms.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Ben Gardiner <bengardiner@nanometrics.ca> writes:

> The da850-evm baseboard (BB) and its UI board both have tca6416 IO expanders.
> They are bootstrapped to different I2C addresses so they can be used
> concurrently.
>
> The expander on the UI board is currently used to enable/disable the
> peripherals that are available on the UI board. In addition to this
> functionality the expander is also connected to 8 pushbuttons. The expander
> on the baseboard is not currently used; it is connected to deep sleep enable,
> sw reset, a push button, some switches and LEDs.
>
> This proposed patch series enables the push buttons and switches on the UI and
> BB expanders using the gpio-keys polling mode patch by Gabor Juhos. Some
> work was performed to test irq-based gpio-keys support on the expanders (a WIP
> patch can be posted on request) but I believe that it is not possible to use 
> irq-based gpio-keys on IO expanders for arm systems at this time. 

Thanks for your patience and persistence on this series, and thanks for
working closely with the input folks to get the issues worked through.

This series looks good to me, so I'll be queuing it in davinci-next for
2.6.38.  It should show up in davinci git shortly.  Please validate
things are working as expected there.  Were there any changes needed to
the defaults in da8xx_omapl_defconfig to enable these features by
default?  or does the Kconfig change in PATCH 5/5 cover it?

Also, I really appreciate the thorough patch descriptions and history
information.   This greatly eases the work of maintainers.  Thanks!

One minor question: the series has a couple of Signed-off-by tags from
Sekhar Nori.  The s-o-b tag is for folks on the delivery path, and based
on what I saw, these should probably be Acked-by tags from Sekhar, since
he certainly helped on the review/test/validate side, but AFAICT, was
not an author or on the delivery path.  If I'm wrong on this (e.g., if
Sekhar actually did author some of those patches) let me know, otherwise
I'll change the s-o-b to Acked-by for Sekhar.

Thanks,

Kevin
