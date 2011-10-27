Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1J0NyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 09:54:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34963 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1J0NyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 09:54:21 -0400
MIME-Version: 1.0
In-Reply-To: <201106292334.24518.rjw@sisk.pl>
References: <201106260054.20578.rjw@sisk.pl>
	<201106292329.04163.rjw@sisk.pl>
	<201106292334.24518.rjw@sisk.pl>
Date: Thu, 27 Oct 2011 15:54:20 +0200
X-Google-Sender-Auth: Ud-xKhZw2z8d-beh-SprLl2OAiI
Message-ID: <CAKnu2Mru4c-2LBCZ_k3ZA+v47u0+um8igYU7EWt8=qOTVgcUjA@mail.gmail.com>
Subject: Re: [PATCH 4/6 v2] PM: Limit race conditions between runtime PM and
 system sleep (v2)
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        linux-scsi@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/29 Rafael J. Wysocki <rjw@sisk.pl>:

> One of the roles of the PM core is to prevent different PM callbacks
> executed for the same device object from racing with each other.
> Unfortunately, after commit e8665002477f0278f84f898145b1f141ba26ee26
> (PM: Allow pm_runtime_suspend() to succeed during system suspend)
> runtime PM callbacks may be executed concurrently with system
> suspend/resume callbacks for the same device.
(...)
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

A quick question: is there some specific reason why this patch should
not go into the 3.0.y stable releases? We are trying to produce
a runtime PM system of product quality based on 3.0.y and we've
already had to backport this patch ourselves to get things stable.

We have also backported:
PM: Introduce generic "noirq" callback routines for subsystems (v2)
PM / Runtime: Update documentation of interactions with system sleep
PM / Runtime: Add new helper function: pm_runtime_status_suspended()

And now it seems to be sufficient to get this thing going.

Yours,
Linus Walleij
