Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab2KKKvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 05:51:48 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51406 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2KKKvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 05:51:47 -0500
MIME-Version: 1.0
In-Reply-To: <509F76D3.29142.1EC611@msetzerii.gmail.com>
References: <509F5A53.26612.2D87FF@msetzerii.gmail.com>
	<CACVXFVPQrA=t6CozL2rkQLnFTvq-bo=xVaMGUYEVAqcvFO2nog@mail.gmail.com>
	<509F76D3.29142.1EC611@msetzerii.gmail.com>
Date: Sun, 11 Nov 2012 18:51:45 +0800
Message-ID: <CACVXFVPt9WiYVNkNm7OPNjsGdxMqyxRwUpx+e4NuUL9+ss6Ppw@mail.gmail.com>
Subject: Re: Kernel Firmware - Adding Right way??
From: Ming Lei <tom.leiming@gmail.com>
To: "Michael D. Setzer II" <msetzerii@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2012 at 5:58 PM, Michael D. Setzer II
<msetzerii@gmail.com> wrote:
>
> The project currently includes 10 different kernels, and prior to my
> taking it over in 2004, it was the same basic setup. Don't really
> know the whole proces that would be required to convert the
> standalone kernels to kernels using moduals. Setting up the
> moduals and the process to load them, which the kernel now does
> automatically. Project has 800 to 1000+ downloads per week.
>
> I see it load the firmware, and the it shows loading the ramdisk
> file, before the probing happens, but don't know if loading the
> ramdisk is the same as making the rootfs available with the

>From the log, looks your kernel loads firmware from fs directly, so
it should be same between ramdisk and rootfs.

> /lib/firmware directory.  Know that is the directory that distros
> seem to use, but perhaps the kernel is using other location.
> Message doesn't specify where it was looking for kernel?

Below is the default path to search firmware by kernel:

static const char *fw_path[] = {
        "/lib/firmware/updates/" UTS_RELEASE,
        "/lib/firmware/updates",
        "/lib/firmware/" UTS_RELEASE,
        "/lib/firmware"
};

>
>> As far as I know, now the preferred approach is to build the
>> driver as module for the issue, or you can introduce probe
>> deferral in driver to solve the problem.
>>
>
> Don't write the drivers, so don't know if this is an option. I've only
> heard of this issue with the bnx2x driver with HP servers and only
> with a couple of users. So, perhaps just manually adding the
> bnx2x.

You can try to make bnx2x as module to see if you problem can be fixed,
and probe deferral for loading firmware is still not ready.


Thanks,
-- 
Ming Lei
