Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2ICNAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:00:52 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46381 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab2ICNAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:00:48 -0400
MIME-Version: 1.0
In-Reply-To: <1346528835-363-1-git-send-email-rydberg@euromail.se>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
Date: Mon, 3 Sep 2012 15:00:47 +0200
Message-ID: <CAN+gG=GKQt7nZKNQP7Z8Y_mp_HaUGqhw9bat8RjCpC19S7H2FQ@mail.gmail.com>
Subject: Re: [PATCH v3 v3 00/20] Input and HID updates for 3.7
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

Indeed, we are getting close. I tested the whole patch set again.
So:
- patches 1 to 19 are not introducing any bugs (at least from what I've seen).
- patch 20 is not good (see the reply in the patch).

So far, devices tested are:
- Elan
- 3M
- Lumio
- Cypress
- Topseed
- Stantum

you can add my "reviewed by" on patches 1, 7, 8, 10, 17, 18 and 19
(those that are more MT related than generic input).
You can also add my 'tested-by' on the whole patch set except for the 20st.

Cheers,
Benjamin


On Sat, Sep 1, 2012 at 9:46 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Dmitry, Jiri,
>
> Here is the third version of the patchset for 3.7. I think we are
> getting close. Changes in short:
>
> Patch 2: Folded the size estimate removal into this patch, since the
> other estimates are still needed for MT-A devices.
>
> Patch 5: Reworked to handle SYN_MT events the 'old' way.
> Patch 10: Reworked to allow for a proper device-to-slot mapping.
> Patch 15: Remove the old size estimate when converting to MT-B.
>
> Patch 18: New patch, carefully perform finalization per input device.
> Patch 19: Shortened version of touch state removal.
>
> Patch 20: New patch, fixing a long-standing bug for devices capable of
> more than ten touches.
>
> Several bugs removed, thanks to everyone involved in finding
> those. The set has been more thoroughly tested, but still needs
> further scrutiny from Benjamin.
>
> Thanks,
> Henrik
>
> Henrik Rydberg (20):
>   Input: Break out MT data
>   Input: Improve the events-per-packet estimate
>   Input: Make sure we follow all EV_KEY events
>   Input: Move autorepeat to the event-passing phase
>   Input: Send events one packet at a time
>   Input: evdev - Add the events() callback
>   Input: MT - Add flags to input_mt_init_slots()
>   Input: MT - Handle frame synchronization in core
>   Input: MT - Add in-kernel tracking
>   Input: MT - Get slot by key
>   Input: bcm5974 - only setup button urb for TYPE1 devices
>   Input: bcm5974 - Preparatory renames
>   Input: bcm5974 - Drop pressure and width emulation
>   Input: bcm5974 - Drop the logical dimensions
>   Input: bcm5974 - Convert to MT-B
>   HID: Only dump input if someone is listening
>   HID: Add an input configured notification callback
>   HID: hid-multitouch: Simplify setup and frame synchronization
>   HID: hid-multitouch: Remove the redundant touch state
>   HID: hid-multitouch: Add missing contact count detection
>
>  drivers/hid/hid-core.c                   |   3 +-
>  drivers/hid/hid-input.c                  |  11 +-
>  drivers/hid/hid-magicmouse.c             |   2 +-
>  drivers/hid/hid-multitouch.c             | 157 ++++++---------
>  drivers/input/evdev.c                    |  78 +++++---
>  drivers/input/input-mt.c                 | 294 +++++++++++++++++++++++++---
>  drivers/input/input.c                    | 245 ++++++++++++++++--------
>  drivers/input/misc/uinput.c              |   2 +-
>  drivers/input/mouse/alps.c               |   2 +-
>  drivers/input/mouse/bcm5974.c            | 317 ++++++++++++-------------------
>  drivers/input/mouse/elantech.c           |   4 +-
>  drivers/input/mouse/sentelic.c           |   2 +-
>  drivers/input/mouse/synaptics.c          |   4 +-
>  drivers/input/tablet/wacom_wac.c         |   6 +-
>  drivers/input/touchscreen/atmel_mxt_ts.c |   2 +-
>  drivers/input/touchscreen/cyttsp_core.c  |   2 +-
>  drivers/input/touchscreen/edt-ft5x06.c   |   2 +-
>  drivers/input/touchscreen/egalax_ts.c    |   2 +-
>  drivers/input/touchscreen/ili210x.c      |   2 +-
>  drivers/input/touchscreen/mms114.c       |   2 +-
>  drivers/input/touchscreen/penmount.c     |   2 +-
>  drivers/input/touchscreen/wacom_w8001.c  |   2 +-
>  include/linux/hid.h                      |   3 +
>  include/linux/input.h                    |  33 +++-
>  include/linux/input/mt.h                 |  55 +++++-
>  25 files changed, 778 insertions(+), 456 deletions(-)
>
> --
> 1.7.12
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
