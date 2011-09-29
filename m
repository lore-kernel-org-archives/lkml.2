Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab1I2P4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:56:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39607 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab1I2P4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:56:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAKPcRGr3EzjS2es6HniuQziEivpsfH2r=d_Y=nkrsFW59g6xSw@mail.gmail.com>
References: <1317288548-19560-1-git-send-email-Barry.Song@csr.com>
	<CAKPcRGr3EzjS2es6HniuQziEivpsfH2r=d_Y=nkrsFW59g6xSw@mail.gmail.com>
Date: Thu, 29 Sep 2011 17:56:43 +0200
Message-ID: <CAKPcRGpPG2Z_tMQFHz8fpBLhLO4dx58AVhYWmPdZ_0pV7pVK6A@mail.gmail.com>
Subject: Re: [PATCH] PM: HIBERNATION: add resume_wait param to support
 MMC-like devices as resume file
From: Luca Tettamanti <kronos.it@gmail.com>
To: Barry Song <Barry.Song@csr.com>
Cc: pavel@ucw.cz, rjw@sisk.pl, frank.hofmann@tomtom.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Barry Song <Baohua.Song@csr.com>,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 5:47 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
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

And in case that makes sense, it might be worthwhile to refactor a
common helper to be also used in do_mounts.c, e.g.
dev_t wait_for_device(char *name)

L
