Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab2LCHgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 02:36:42 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37147 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2LCHgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 02:36:40 -0500
Date: Sun, 2 Dec 2012 23:36:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, David Solda <dso@cypress.com>,
        Troy Abercrombia <ta@cypress.com>, Dudley Du <dudl@cypress.com>,
        Cypress Semiconductor Corporation <customercare@cypress.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: Re: [PATCH v3 0/4] Cypress PS/2 Trackpad driver
Message-ID: <20121203073636.GA28682@core.coreip.homeip.net>
References: <1354226281-3476-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354226281-3476-1-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamal,

On Thu, Nov 29, 2012 at 01:57:57PM -0800, Kamal Mostafa wrote:
> This driver, submitted on behalf of Cypress Semiconductor Corporation and
> additional contributors, provides support for the Cypress PS/2 Trackpad.
> 
> This [PATCH v3] version differs from my previous submitted version[1]:
> 
>   Patch #1 (cmdbuf to 8 bytes) and #3 (link in driver) are unchanged.
> 
>   Patch #2 (main driver), as recommended by Henrik Rydberg[2]:
>   - use input_mt_assign_slots; drop cypress_cal_finger_id.
>   - enable 2-finger-only SEMI_MT; drop cypress_simulate_fingers.
>   - various code clean-ups.
> 
>   Henrik, does patch #2 appear to properly use assign_slots and SEMI_MT as
>   you intended?  This SEMI_MT method does work (with 2 finger support only),
>   but I'm not clear why we wouldn't want to handle >2 fingers also, so ...
> 
>   Patch #4 (new) reintroduces simulated multitouch for up to 5 fingers
>   (#if CYPRESS_SIMULATE_MT), disabling SEMI_MT again.
> 
>   If that functionality (support for >2 fingers) can be acheived in some
>   better way, please advise.

You can still report true number of fingers on the pad via BTN_TOOL_*TAP
while reporting the bounding box, the same way as Synaptics, Elantech,
ALPS and Sentelic drivers are doing it.

Thanks.

-- 
Dmitry
