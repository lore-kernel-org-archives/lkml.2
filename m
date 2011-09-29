Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1I2ILY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:11:24 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42795 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1I2ILU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:11:20 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.124.210]
In-Reply-To: <201109242326.48485.rjw@sisk.pl>
References: <201108310017.03103.rjw@sisk.pl>
	<201109242323.03474.rjw@sisk.pl>
	<201109242326.48485.rjw@sisk.pl>
Date: Thu, 29 Sep 2011 10:11:18 +0200
Message-ID: <CAORVsuUopAWQuFkn1cURiv+YhEUT6=SQV5NRL5N1Y1oYn9d2NQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] PM / QoS: Add function dev_pm_qos_read_value() (v2)
From: Jean Pihet <jean.pihet@newoldbits.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Ming Lei <tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

I have a few minor remarks, inlined below.

On Sat, Sep 24, 2011 at 11:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> To read the current PM QoS value for a given device we need to
> make sure that the device's power.constraints object won't be
> removed while we're doing that.  For this reason, put the
> operation under dev->power.lock and acquire the lock
> around the initialization and removal of power.constraints.
>
> Moreover, since we're using the value of power.constraints to
> determine whether or not the object is present, the
> power.constraints_state field isn't necessary any more and may be
> removed.  However, dev_pm_qos_add_request() needs to check if the
> device is being removed from the system before allocating a new
> PM QoS constraints object for it, so it has to use device_pm_lock()
> and the device PM QoS initialization and destruction should be done
> under device_pm_lock() as well.
It might be good to mention dev_pm_qos_mtx which is used internally by
the per-device PM QoS code.

>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Other then the minor remarks:
Acked-by: Jean Pihet <j-pihet@ti.com>

> ---
>  drivers/base/power/main.c |    4 -
>  drivers/base/power/qos.c  |  168 ++++++++++++++++++++++++++--------------------
>  include/linux/pm.h        |    8 --
>  include/linux/pm_qos.h    |    3
>  4 files changed, 103 insertions(+), 80 deletions(-)
>
> Index: linux/drivers/base/power/qos.c
> ===================================================================
> --- linux.orig/drivers/base/power/qos.c
> +++ linux/drivers/base/power/qos.c
...

>
> +static void __dev_pm_qos_constraints_init(struct device *dev)
I would change the name or add a comment stating that this is an
internal function which reinits the constraints field under the lock.

Thanks & regards,
Jean
