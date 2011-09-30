Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab1I3IIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:08:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59027 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab1I3IIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:08:37 -0400
MIME-Version: 1.0
X-Originating-IP: [81.245.118.199]
In-Reply-To: <201109292233.52378.rjw@sisk.pl>
References: <201108310017.03103.rjw@sisk.pl>
	<201109242326.48485.rjw@sisk.pl>
	<CAORVsuUopAWQuFkn1cURiv+YhEUT6=SQV5NRL5N1Y1oYn9d2NQ@mail.gmail.com>
	<201109292233.52378.rjw@sisk.pl>
Date: Fri, 30 Sep 2011 10:08:36 +0200
Message-ID: <CAORVsuV4ccJvJg-zCrhVXJKmHkEYLLQh032=BMh7qH27bTK5uQ@mail.gmail.com>
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

On Thu, Sep 29, 2011 at 10:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> On Thursday, September 29, 2011, Jean Pihet wrote:
>> Hi Rafael,
>>
>> I have a few minor remarks, inlined below.
>
> In the meantime it turned out that the patch caused a build failure
> for CONFIG_PM_SLEEP unset (your original patches won't really work
> in this case too), so I posted a patch to fix it.  However, since
> you had remarks anyway, I've simply folded the fix into the next
> version of the $subject patch, which is appended.
OK to me.

I have 2 remarks though:
- some drivers are using the power_state field in the suspend/resume
operation, IIUC without conflict. Can you confirm?
- the power_state field is scheduled for removal, cf.
Documentation/feature-removal-schedule.txt. That does not look
correct.

...
>> > +static void __dev_pm_qos_constraints_init(struct device *dev)
>> I would change the name or add a comment stating that this is an
>> internal function which reinits the constraints field under the lock.
>
> This function was used only once, so it wasn't really necessary.  I simply
> removed it.
>
> Thanks,
> Rafael
>
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / QoS: Add function dev_pm_qos_read_value() (v3)
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
> PM QoS constraints object for it, so make it use the
> power.power_state field of struct device for this purpose.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Regards,
Jean
