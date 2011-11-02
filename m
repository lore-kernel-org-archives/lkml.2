Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab1KBUGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:06:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38746 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1KBUGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:06:03 -0400
MIME-Version: 1.0
In-Reply-To: <20111102191432.GC29355@kroah.com>
References: <201106260054.20578.rjw@sisk.pl>
	<201106292329.04163.rjw@sisk.pl>
	<201106292334.24518.rjw@sisk.pl>
	<CAKnu2Mru4c-2LBCZ_k3ZA+v47u0+um8igYU7EWt8=qOTVgcUjA@mail.gmail.com>
	<20111102191432.GC29355@kroah.com>
Date: Wed, 2 Nov 2011 21:06:02 +0100
Message-ID: <CACRpkdY8zAw_pdwn2yUEJPdfYPS+VCcLrpucZzhCyNsVPYehdg@mail.gmail.com>
Subject: Re: [PATCH 4/6 v2] PM: Limit race conditions between runtime PM and
 system sleep (v2)
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        linux-scsi@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, Ulf Hansson <Ulf.Hansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 8:14 PM, Greg KH <greg@kroah.com> wrote:

>> We have also backported:
>> PM: Introduce generic "noirq" callback routines for subsystems (v2)
>> PM / Runtime: Update documentation of interactions with system sleep
>> PM / Runtime: Add new helper function: pm_runtime_status_suspended()
>>
>> And now it seems to be sufficient to get this thing going.
>
> So, what specific git commits do you want to see in the 3.0-stable
> tree, and in what order should they be applied in?

So to my untrained eye it looks like it should be applied like this (top to
bottom) using the reverse commit order from the mainline kernel:

e529192 PM: Introduce generic "noirq" callback routines for subsystems (v2)
455716e PM / Runtime: Update documentation of interactions with system sleep
1e2ef05 PM: Limit race conditions between runtime PM and system sleep (v2)
f3393b6 PM / Runtime: Add new helper function: pm_runtime_status_suspended()

So (2) documents the problem, (3) fixes it, whereas (1) and (4) makes
it possible
to write proper _noirq() code that does not race, IIRC.

Yours,
Linus Walleij
