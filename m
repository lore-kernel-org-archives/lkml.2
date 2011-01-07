Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1AGVyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 16:54:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38590 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1AGVx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 16:53:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=axhj95hmV1zTecxe+i5Edxlm47Iv79qDqDupvfXWXwxlR0cXWSuG9wI/REyUVC54SQ
         tdF90+GcYpylSZsfPYV+0rAsr7nxphdCiuuGixSfq6girjqdxiycXaRvHGuML+2Erbkj
         SxPv13WfzXfTAUXb6ktbTuroJ0RJQi7NtjKkg=
Date: Fri, 7 Jan 2011 13:53:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Nikolai Kondrashov <spbnick@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Documentation: Add evdev type and code definitions
Message-ID: <20110107215353.GF28875@core.coreip.homeip.net>
References: <1294435695-16750-1-git-send-email-chase.douglas@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294435695-16750-1-git-send-email-chase.douglas@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chase,

On Fri, Jan 07, 2011 at 04:28:15PM -0500, Chase Douglas wrote:
> +
> +* KEY_SUSPEND, KEY_POWER:
> +  - These codes are reserved for the EV_PWR type.
> +

This is not correct, KEY_SUSPEND and KEY_POWER are valid events for
EV_KEY type. We need to figure out what to do with drivers who like to do
EV_PWR/KEY_PWR though.

The whole EV_PWR business is iffy. IIRC/IIUC it was envisioned to semd
powwer events _to_ the devices to implement device-level PM. We'll have
to revisit it at some point.


> +EV_REL:
> +----------
> +EV_REL events describe relative changes in a property. For example, a mouse may
> +move to the left by a certain number of units, but its absolute position in
> +space is unknown. If the absolute position is known, EV_ABS codes should be used
> +instead of EV_REL codes.
> +
> +A few EV_REL codes have special meanings:
> +
> +* REL_WHEEL, REL_HWHEEL:
> +  - These codes are used for vertical and horizontal scroll wheels,
> +    respectively.
> +
> +EV_ABS:
> +----------
> +EV_ABS events describe absolute changes in a property. For example, a touchpad
> +may emit coordinates for a touch location.
> +
> +A few EV_ABS codes have special meanings:
> +
> +* ABS_DISTANCE:
> +  - Used to describe the distance of a tool from an interaction surface. This
> +    should only be used while the tool is hovering, meaning in close proximity
> +    of the device. If the input device may be used freely in three dimensions,
> +    consider ABS_Z instead.
> +
> +* ABS_MT_<name>:
> +  - Used to describe multitouch input events. Please see
> +    multi-touch-protocol.txt for details.
> +
> +EV_SW:
> +----------
> +EV_SW events describe stateful binary switches. For example, the SW_LID code is
> +used to denote when a laptop lid is closed.

Please add that drivers should refresh switch state upon binding to a
device and also upon resume.

> +
> +EV_MSC:
> +----------
> +EV_MSC events are used for input and output events that do not fall under other
> +categories.
> +
> +EV_LED:
> +----------
> +EV_LED events are used for input and output to set and query the state of
> +various LEDs on devices.
> +
> +EV_REP:
> +----------
> +EV_REP events are used for specifying autorepeating events.
> +
> +EV_SND:
> +----------
> +EV_SND events are used for sending sound commands to simple sound output
> +devices.
> +
> +EV_FF:
> +----------
> +EV_FF events are used to initialize a force feedback capable device and to cause
> +such device to feedback.
> +
> +EV_PWR:
> +----------
> +EV_PWR events are a special type of key event used specifically for monitoring
> +power buttons and switches. The two codes in use are:
> +
> +* KEY_POWER:
> +  - Used to denote a power button event.
> +
> +* KEY_SUSPEND:
> +  - Used to denote a suspend button event.

Just replace this with TBA for now.

Thanks.

-- 
Dmitry
