Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1BGA6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 19:58:33 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63667 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab1BGA6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 19:58:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jDlOm+firO6eBYFQE5zQT3shkAUa2K6WmL40LDrO7KgCMSQJcPdOy50zMn/llzuhLn
         vhNEvQ78J2kvAEVJizI2ZZUMj42q0yTUDhg0pQmWvRlr51rN15hcm2FYG/JTrwWpHeBs
         Eps0B39IZgiicIgSQaHONu/ojWzxnkTf7a4nA=
MIME-Version: 1.0
In-Reply-To: <1296953291-10373-1-git-send-email-lars@metafoo.de>
References: <1296953291-10373-1-git-send-email-lars@metafoo.de>
Date: Mon, 7 Feb 2011 02:58:32 +0200
Message-ID: <AANLkTimN1ACy=rREGhvAqTwfywHb7_Td7ZeKosQc9txC@mail.gmail.com>
Subject: Re: [PATCH 00/14] POWER: BQ27x00: New Properties, fixes, bq27000 support
From: Grazvydas Ignotas <notasas@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 6, 2011 at 2:47 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> This patch series contains a few updates for the bq27x00 driver:
> * Support for additional power supply properties
> * Support for the bq27000 battery which is identical to the bq27200 but is
>  connected through the HDQ bus.
> * Adds a register cache to the driver and introduces polling the batteries state
> * Minor improvements and cleanups
>
> The last patch in this series is not specific to the bq27x00 driver but is
> required for uevents to be generated properly for this driver.
> The patch makes properties which return -ENODATA to be ignored when generating
> uevents. Previously in such a case uevent generation would have been aborted
> with an error. But since the bq27x00 return -ENODATA for the TIME_TO_FULL
> property when the battery is not charging and for the TIME_TO_EMPTY property
> when the battery is not discharging and at least one of them is always true
> uevent generation would always fail.
>
> This series has so far been tested with the bq27000 and the bq27200 battery, but
> not with the bq27500 battery, so it would be nice if somebody with a board
> containing such a battery could test the patches to make sure that there are no
> regressions.

Trying this on pandora board (bq27500 over i2c) and it seems there is
something wrong with the cache, I'm always getting the old values. I'm
reading them manually over sysfs, uptime is over 25min but values
still match ones on boot, even after turning off the backlight.

Looking at the code delayed_work handling looks suspicious,
bq27x00_battery_get_property() flushes it and nothing ever reschedules
it. Other than that all new property values looks sane.
