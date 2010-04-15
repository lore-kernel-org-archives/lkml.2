Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0DOL4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:56:45 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57322 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab0DOL4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:56:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AYZNr+CaOpFAb4aLwDITC0WeHruZpUVEFuam6/mQAHOsJ9192pSpBSeesuvg7JX+qk
         L3nfVSSeRUOWslZdNsGSxN9lgduSfn9W3sL3ivKV76rsYo8KajGRH90VPGRENEhhaZmp
         845motdGjRnDIux9cFzOYSvzxFDoXbYf0mgBc=
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1004150239391.28179@twin.jikos.cz>
References: <1271271162.9281.1.camel@localhost>
	 <alpine.LRH.2.00.1004150239391.28179@twin.jikos.cz>
Date: Thu, 15 Apr 2010 13:56:42 +0200
Message-ID: <h2h8aa016e11004150456u5b9eb7f0sa7501f2fa4c0bf13@mail.gmail.com>
Subject: Re: WARNING: at kernel/lockdep.c:2696 lockdep_init_map+0xd2/0x108()
From: Dhaval Giani <dhaval.giani@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 2:45 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 14 Apr 2010, Dhaval Giani wrote:
>
>> Hi Peter,
>>
>> I seem to be hitting this on bootup on a recent-ish git kernel (post
>> -rc4).
>
> The patch below should fix it, does it, Dhaval?
>

yep! It does the job! Thanks for fixing it.

> Adding Greg and Eric to CC ... Greg, will you take it through your tree
> please?
>
> Thanks.
>
>
>
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] sysfs: use sysfs_attr_init in ASUS atk0110 driver
>
> Annotate dynamic sysfs attribute in atk_create_files(). This gets
> rid of the following lockdep warning:
>
>  BUG: key ffff8800379ca670 not in .data!
>  ------------[ cut here ]------------
>  WARNING: at kernel/lockdep.c:2696 lockdep_init_map+0xd2/0x108()
>  Hardware name: P5K PRO
>  Modules linked in: asus_atk0110(+) pata_acpi firewire_ohci ata_generic
>  dm_multipath firewire_core crc_itu_t pata_marvell floppy
>  Pid: 599, comm: modprobe Not tainted 2.6.34-rc4 #27
>  Call Trace:
>  [<ffffffff8104cdb0>] warn_slowpath_common+0x7c/0x94
>  [<ffffffff8104cddc>] warn_slowpath_null+0x14/0x16
>  [<ffffffff81077c4d>] lockdep_init_map+0xd2/0x108
>  [<ffffffff81165873>] sysfs_add_file_mode+0x66/0xa2
>  [<ffffffff811658c0>] sysfs_add_file+0x11/0x13
>  [<ffffffff8116594b>] sysfs_create_file+0x2a/0x2c
>  [<ffffffff812c1f9c>] device_create_file+0x19/0x1b
>  [<ffffffffa005b4fd>] atk_add+0x58b/0x72e [asus_atk0110]
>  [<ffffffff812572a1>] acpi_device_probe+0x50/0x122
>  [<ffffffff812c46af>] driver_probe_device+0xa2/0x127
>  [<ffffffff812c4783>] __driver_attach+0x4f/0x6b
>  [<ffffffff812c4734>] ? __driver_attach+0x0/0x6b
>  [<ffffffff812c3c94>] bus_for_each_dev+0x59/0x8e
>  [<ffffffff812c4519>] driver_attach+0x1e/0x20
>  [<ffffffff812c4152>] bus_add_driver+0xb9/0x207
>  [<ffffffff812c4a5f>] driver_register+0x9d/0x10e
>  [<ffffffffa005f000>] ? atk0110_init+0x0/0x31 [asus_atk0110]
>  [<ffffffff81257c7c>] acpi_bus_register_driver+0x43/0x45
>  [<ffffffffa005f015>] atk0110_init+0x15/0x31 [asus_atk0110]
>  [<ffffffffa005f000>] ? atk0110_init+0x0/0x31 [asus_atk0110]
>  [<ffffffff81002069>] do_one_initcall+0x5e/0x15e
>  [<ffffffff81085075>] sys_init_module+0xd8/0x239
>  [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
>  ---[ end trace 4d0c84007055efb9 ]---
>  BUG: key ffff8800379ca638 not in .data!
>  BUG: key ffff8800379ca6a8 not in .data!
>  BUG: key ffff8800379ca6e0 not in .data!
>  BUG: key ffff880036f73670 not in .data!
>  BUG: key ffff880036f73638 not in .data!
>  BUG: key ffff880036f736a8 not in .data!
>  BUG: key ffff880036f736e0 not in .data!
>  BUG: key ffff880036f76c70 not in .data!
>  BUG: key ffff880036f76c38 not in .data!
>  BUG: key ffff880036f76ca8 not in .data!
>  BUG: key ffff880036f76ce0 not in .data!
>  BUG: key ffff8800368e7670 not in .data!
>  BUG: key ffff8800368e7638 not in .data!
>  BUG: key ffff8800368e76a8 not in .data!
>  BUG: key ffff8800368e76e0 not in .data!
>  BUG: key ffff880036ef7670 not in .data!
>  BUG: key ffff880036ef7638 not in .data!
>  BUG: key ffff880036ef76a8 not in .data!
>  BUG: key ffff880036ef76e0 not in .data!
>  BUG: key ffff8800373ccc70 not in .data!
>  BUG: key ffff8800373ccc38 not in .data!
>  BUG: key ffff8800373ccca8 not in .data!
>  BUG: key ffff8800373ccce0 not in .data!
>  BUG: key ffff880037a60870 not in .data!
>  BUG: key ffff880037a60838 not in .data!
>  BUG: key ffff880037a608a8 not in .data!
>  BUG: key ffff880037a608e0 not in .data!
>  BUG: key ffff880037355070 not in .data!
>  BUG: key ffff880037355038 not in .data!
>  BUG: key ffff8800373550a8 not in .data!
>  BUG: key ffff8800373550e0 not in .data!
>  BUG: key ffff8800378c2670 not in .data!
>  BUG: key ffff8800378c2638 not in .data!
>  BUG: key ffff8800378c26a8 not in .data!
>  BUG: key ffff8800378c26e0 not in .data!
>  BUG: key ffff880036ef7e70 not in .data!
>  BUG: key ffff880036ef7e38 not in .data!
>  BUG: key ffff880036ef7ea8 not in .data!
>  BUG: key ffff880036ef7ee0 not in .data!
>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Reported-by: Dhaval Giani <dhaval.giani@gmail.com>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>

Tested-by: Dhaval Giani <dhaval.giani@gmail.com>

> ---
>  drivers/hwmon/asus_atk0110.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/hwmon/asus_atk0110.c b/drivers/hwmon/asus_atk0110.c
> index 75f3fa5..16c4202 100644
> --- a/drivers/hwmon/asus_atk0110.c
> +++ b/drivers/hwmon/asus_atk0110.c
> @@ -1169,15 +1169,19 @@ static int atk_create_files(struct atk_data *data)
>        int err;
>
>        list_for_each_entry(s, &data->sensor_list, list) {
> +               sysfs_attr_init(&s->input_attr.attr);
>                err = device_create_file(data->hwmon_dev, &s->input_attr);
>                if (err)
>                        return err;
> +               sysfs_attr_init(&s->label_attr.attr);
>                err = device_create_file(data->hwmon_dev, &s->label_attr);
>                if (err)
>                        return err;
> +               sysfs_attr_init(&s->limit1_attr.attr);
>                err = device_create_file(data->hwmon_dev, &s->limit1_attr);
>                if (err)
>                        return err;
> +               sysfs_attr_init(&s->limit2_attr.attr);
>                err = device_create_file(data->hwmon_dev, &s->limit2_attr);
>                if (err)
>                        return err;
>
