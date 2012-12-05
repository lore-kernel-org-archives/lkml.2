Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2LECWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 21:22:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58874 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab2LECWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 21:22:20 -0500
Message-ID: <1354674138.11174.86.camel@fourier>
Subject: SEMI_MT vs. simulated mt (was Re: [PATCH v3 0/4] Cypress PS/2
 Trackpad driver)
From: Kamal Mostafa <kamal@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Dudley Du <dudl@cypress.com>
Cc: linux-kernel@vger.kernel.org, David Solda <dso@cypress.com>,
        Troy Abercrombia <ta@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        linux-input@vger.kernel.org, Tim Gardner <tim.gardner@canonical.com>
Date: Tue, 04 Dec 2012 18:22:18 -0800
In-Reply-To: <20121203073636.GA28682@core.coreip.homeip.net>
References: <1354226281-3476-1-git-send-email-kamal@canonical.com>
	 <20121203073636.GA28682@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry and Henrik-

Regarding SEMI_MT vs. "simulated multitouch" . . .

> > 
> >   Patch #4 (new) reintroduces simulated multitouch for up to 5 fingers
> >   (#if CYPRESS_SIMULATE_MT), disabling SEMI_MT again.
> > 
> >   If that functionality (support for >2 fingers) can be acheived in some
> >   better way, please advise.


On Sun, 2012-12-02 at 23:36 -0800, Dmitry Torokhov wrote:
> You can still report true number of fingers on the pad via BTN_TOOL_*TAP
> while reporting the bounding box, the same way as Synaptics, Elantech,
> ALPS and Sentelic drivers are doing it.


On Mon, 2012-12-03 at 08:45 +0100, Henrik Rydberg wrote:
> +		ret = input_mt_init_slots(input, CYTP_MAX_MT_SLOTS,
> +			INPUT_MT_POINTER|INPUT_MT_DROP_UNUSED|INPUT_MT_TRACK);
> 
> Here, INPUT_MT_POINTER needs to be dropped; for semi-mt devices, the
> number of fingers is propagated separately using
> 
>    input_mt_report_finger_count(dev, finger_count_as_reported_by_the_device),
> 
> which conflicts with automatic handling of pointer logic.


Well...  The forthcoming PATCH v4 version now implements all that ^^ as
you requested, but it appears that my desktop (X with Unity desktop in
Ubuntu 12.10) does not actually respond to input_mt_report_finger_count
events (e.g. BTN_TOOL_TRIPLETAP).

I asked a colleague test a couple of other semi-mt touchpads (Synaptics
and ALPS) and we found the same result:  The desktop doesn't see >2
finger events with any of these semi-mt devices, even though
'input-events' does show that the BTN_TOOL_*TAP events are in the input
stream.  (Do other X desktops actually support BTN_TOOL_*TAP?)

I understand that this may be "a userspace problem", but from my
perspective the "simulated multitouch" patch is still necessary for >2
finger tap/drag.  I have left it in my PATCH v4 set for that reason
(patch 4/4; disabled by an ifdef).  It can be included and left
disabled, or enabled, or dropped as you see fit.

 -Kamal


