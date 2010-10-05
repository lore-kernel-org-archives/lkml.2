Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab0JEBvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 21:51:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53147 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab0JEBvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 21:51:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZdzPd8atwSrHM28ZvxH5UYLizMoGtSBCzp8B8sjBn6LnF17t4LAH/V24LK8q/+xv72
         I/k79RsTwF5cVpdh2HYvxXuP/yyryN4EvQYRQrMHt3TdKmAo9++VEjDMU0GYda8PDE2a
         VCTUIM7q8vH02JtI9tetP3jYass8uz9qU8Hd4=
MIME-Version: 1.0
In-Reply-To: <4CAA5BDA.7080705@tuxonice.net>
References: <4CAA5BDA.7080705@tuxonice.net>
Date: Tue, 5 Oct 2010 11:51:29 +1000
Message-ID: <AANLkTikzSQuBOWR=Bf_3xuS+ioyvZ3LLXGuRnN-CHj7p@mail.gmail.com>
Subject: Re: [BUG][PATCH] 2.6.36-rc showstopper (at least for me) in vmwgfx
From: Dave Airlie <airlied@gmail.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: Dave Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 8:57 AM, Nigel Cunningham <nigel@tuxonice.net> wrote:
> Running a kernel based on the Rafael's -next tree, under VMware, I get the following oops while booting:

Should already be fixed in Linus tree by,
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f1a28ee238bddfa48c5233543926af65a4445bf6

Dave.

>
> Entering kdb (current=0xd73e2f70, pid 1024) on processor 0 Oops: (null)
> due to oops @ 0xc108bc94
> <d>Modules linked in: ext4 jbd2 crc16 mptspi mptscsih mptbase
> <c>
> <d>Pid: 1024, comm: plymouthd Not tainted 2.6.36-rc4+ #60 440BX Desktop Reference Platform/VMware Virtual Platform
> <d>EIP: 0060:[<c108bc94>] EFLAGS: 00010246 CPU: 0
> EIP is at kfree+0x36/0x88
> <d>EAX: c146ccbd EBX: dc46e980 ECX: 40000400 EDX: c182cd80
> <d>ESI: dfabf800 EDI: dfabf8c0 EBP: dfa7befc ESP: dfa7beec
> <d> DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> <0>Process plymouthd (pid: 1024, ti=dfa7a000 task=d73e2f70 task.ti=dfa7a000)
> <0>Stack:
>  dfabf800 dc46e980 dfabf800 dfabf8c0 dfa7bf18 c11c4ea0 c11d237c dfabf8c0
> <0> dc46e980 c11c4e13 c11d5bd9 dfa7bf28 c113d3d1 dc437468 dc46e780 dfa7bf34
> <0> c11c4d9d dc437468 dfa7bf40 c11d5f35 dfabf800 dfa7bf68 c11c1e3e dfabf800
> <0>Call Trace:
> <0> [<c11c4ea0>] ? drm_master_destroy+0x8d/0xf0
> <0> [<c11d237c>] ? ttm_object_file_destroy+0x0/0xd
> <0> [<c11c4e13>] ? drm_master_destroy+0x0/0xf0
> <0> [<c11d5bd9>] ? vmw_master_drop+0x0/0x76
> <0> [<c113d3d1>] ? kref_put+0x39/0x42
> <0> [<c11c4d9d>] ? drm_master_put+0x12/0x1b
> [0]more>
> Only 'q' or 'Q' are processed at more prompt, input ignored
> <0> [<c11d5f35>] ? vmw_postclose+0x1b/0x25
> <0> [<c11c1e3e>] ? drm_release+0x459/0x4cb
> <0> [<c1091274>] ? fput+0xcc/0x1b1
> <0> [<c108ec5b>] ? filp_close+0x51/0x5b
> <0> [<c108ecbf>] ? sys_close+0x5a/0x88
> <0> [<c1002690>] ? sysenter_do_call+0x12/0x26
> <0>Code: 10 76 72 8d 90 00 00 00 40 c1 ea 0c c1 e2 05 03 15 00 1b 7e c1 66 83 3a 00 79 03 8b 52 0c 8b 0a 84 c9 78 14 66 f7 c1 00 c0 75 04 <0f> 0b eb fe 89 d0 e8 0a 3a fe ff eb 3d 8b 75 04 8b 5a 0c 9c 8f
> Call Trace:
>  [<c11c4ea0>] drm_master_destroy+0x8d/0xf0
>  [<c11d237c>] ? ttm_object_file_destroy+0x0/0xd
>  [<c11c4e13>] ? drm_master_destroy+0x0/0xf0
>  [<c11d5bd9>] ? vmw_master_drop+0x0/0x76
>  [<c113d3d1>] kref_put+0x39/0x42
>  [<c11c4d9d>] drm_master_put+0x12/0x1b
>  [<c11d5f35>] vmw_postclose+0x1b/0x25
>  [<c11c1e3e>] drm_release+0x459/0x4cb
>  [<c1091274>] fput+0xcc/0x1b1
>  [<c108ec5b>] filp_close+0x51/0x5b
>  [<c108ecbf>] sys_close+0x5a/0x88
>  [<c1002690>] sysenter_do_call+0x12/0x26
>
> This oops is caused by vmwgfx setting it's dev->devicename to a static char * instead of kmallocing memory. The kfree that's done in drm_master_destroy then explodes :)
>
> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
>
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> index 72ec2e2..1ca0ebc 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
> @@ -343,8 +343,16 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
>
>        dev->dev_private = dev_priv;
>
> -       if (!dev->devname)
> -               dev->devname = vmw_devname;
> +       if (!dev->devname) {
> +               dev->devname = kmalloc(strlen(vmw_devname) + 1, GFP_KERNEL);
> +               if (!dev->devname) {
> +                       DRM_ERROR("Unable to allocate memory for device "
> +                                       "name.\n");
> +                       ret = -ENOMEM;
> +                       goto out_err4;
> +               }
> +               strcpy(dev->devname, vmw_devname);
> +       }
>
>        if (dev_priv->capabilities & SVGA_CAP_IRQMASK) {
>                ret = drm_irq_install(dev);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
