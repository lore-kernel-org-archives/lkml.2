Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3AIFn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 00:43:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab3AIFn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 00:43:26 -0500
Date: Wed, 9 Jan 2013 00:43:21 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Guangliang Zhao <gzhao@suse.com>
cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, lucienchao@gmail.com,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/3 v3] add resync speed control for dm-raid1
In-Reply-To: <1357552933-26126-1-git-send-email-gzhao@suse.com>
Message-ID: <Pine.LNX.4.64.1301090034200.29917@file.rdu.redhat.com>
References: <1357552933-26126-1-git-send-email-gzhao@suse.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I did this already some times ago.
I'm sending my patches in the next mail.

Basically, my and Guangliang's patches have the following differences:

my patch: uses per-module throttle settings
Guangliang's patch: uses per-device settings
(my patch could be changed to use per-device throttle too, but without 
userspace support it isn't much useful because userspace lvm can 
reload the mirror and per-device settings would be lost)

my patch: uses fine grained throttling of the individual IOs in kcopyd - 
it measures active/inactive ratio and if the disk is active more than the 
specified percentage of time, sleep is inserted.
Guangliang's patch: throttles on segment granularity, it waits when 
starting new segment, but segment is copied unthrottled.

my patch: the user selects a percentage value (0 - 100) in 
"/sys/module/dm_mirror/parameters/raid1_resync_throttle", the device is 
kept active the specified percent of time
Guangliang's patch: limits the number of segments per a specified 
interval

My patch is noticeably bigger.

Mikulas


On Mon, 7 Jan 2013, Guangliang Zhao wrote:

> Hi,
> 
> These patches are used to add resync speed control for dm-raid1. The
> second and third patch provide support for user-space tool dmsetup.
> I have made some modifications by the comments. This is the third
> version.
> 
> Guangliang Zhao (3):
>   dm raid1: add resync speed control for dm-raid1
>   dm raid1: add interface to set resync speed
>   dm raid1: add interface to get resync speed
> 
>  drivers/md/dm-raid1.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 89 insertions(+), 1 deletion(-)
> 
> -- 
> 1.7.10.4
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
