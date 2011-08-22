Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab1HVLP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 07:15:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab1HVLPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 07:15:51 -0400
Message-ID: <4E523A63.3060405@redhat.com>
Date: Mon, 22 Aug 2011 13:15:47 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Q: /sys/block and I/O Schedulers
References: <4E52473A020000A1000070BC@gwsmtp1.uni-regensburg.de>
In-Reply-To: <4E52473A020000A1000070BC@gwsmtp1.uni-regensburg.de>
X-Enigmail-Version: 1.2.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2011 12:10 PM, Ulrich Windl wrote:
> I have a question: Reading the docs on I/O Schedulers, I had the
> impression the docs wanted to tell me that only the low-level devices
> (i.e. disks) use I/O Schedulers, while higher-level devices (like
> multipaths, RAIDs, LVs, etc.) don't.

As you already found, low-level device has always real io scheduler.

Device-mapper use stacked device logic - IOW mapped device
is stacked over some real device(s).

Remapping works on bio level, not on IO request level.
Separate bios are simple remapped to low-level devices where
io scheduler does its job.

There is one exception: dm-multipath which uses "request based" mapping,
IOW it means it uses own scheduler on device-mapper level
(But in old kernels it was on bio level as well,
for more info see https://lkml.org/lkml/2008/2/15/411)

> Using the SLES11 SP1 kernel (2.6.32.43-0.4-xen), I found out that LVs
> seem to use the I/O Scheduler

LVs (e.g. linear mappings) do not use own scheduler. But /queue directory
contains more attributes which need to be visible there.

> My test was as simple as this: /sys/block # for d in *
>> do echo $d: $(<$d/queue/scheduler) done

Btw see "lsblk -t" - here you can see stacked devices with scheduler
and topology info parsed from sysfs (in new util-linux).

Milan
