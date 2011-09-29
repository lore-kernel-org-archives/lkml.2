Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1I2XRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:17:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38127 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab1I2XRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:17:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAKPcRGr3EzjS2es6HniuQziEivpsfH2r=d_Y=nkrsFW59g6xSw@mail.gmail.com>
References: <1317288548-19560-1-git-send-email-Barry.Song@csr.com> <CAKPcRGr3EzjS2es6HniuQziEivpsfH2r=d_Y=nkrsFW59g6xSw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 30 Sep 2011 07:16:57 +0800
Message-ID: <CAGsJ_4zjRpEx_yLwXx74uipPN-Q2hun3AdLxKw2EYOy00cDm3Q@mail.gmail.com>
Subject: Re: [PATCH] PM: HIBERNATION: add resume_wait param to support
 MMC-like devices as resume file
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Barry Song <Barry.Song@csr.com>, frank.hofmann@tomtom.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, rjw@sisk.pl, pavel@ucw.cz,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/29 Luca Tettamanti <kronos.it@gmail.com>:
> On Thu, Sep 29, 2011 at 11:29 AM, Barry Song <Barry.Song@csr.com> wrote:
>> From: Barry Song <baohua.song@csr.com>
>>
>> Some devices like mmc are async detected very slow. For example,
>> drivers/mmc/host/sdhci.c launchs a 200ms delayed work to detect
>> mmc partitions then add disk.
>>
>> we do have wait_for_device_probe and scsi_complete_async_scans
>> before calling swsusp_check, but it is not enough to wait mmc.
>>
>> This patch adds resumewait kernel param just like rootwait so
>> that we have enough time to wait mmc ready. The differene is
>> here we wait for resume partition but rootwait waits for rootfs
>> partition.
>
> I assume that such a device would need "rootwait" to boot in the first
> place; why don't you "overload" the param to also enable waiting in
> the resume path?

not real. for an embedded product, the type of the rootfs, the place
of the rootfs  and the way to mount rootfs are pretty flexible.
even though both rootfs and resume file use mmc, they will be in
different partitions at least. so i don't think rootwait can overload
resumewait.


>
> Luca
>
-barry
