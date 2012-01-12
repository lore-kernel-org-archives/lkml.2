Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab2ALQF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:05:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35762 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab2ALQFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:05:55 -0500
MIME-Version: 1.0
In-Reply-To: <20120112154613.GA10148@phenom.dumpdata.com>
References: <498097597.20120112133832@eikelenboom.it> <20120112154613.GA10148@phenom.dumpdata.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 12 Jan 2012 17:05:34 +0100
Message-ID: <CAPXgP1373C5SfzU-rfo5GG53dUE6dVzECSuKzX1c_FirpXQt2g@mail.gmail.com>
Subject: Re: linux 3.3-pre-rc1: Starting domU fails with Error: Failed to
 query current memory allocation of dom0.
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>, linux-kernel@vger.kernel.org,
        xen-devel <xen-devel@lists.xensource.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 16:46, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Thu, Jan 12, 2012 at 01:38:32PM +0100, Sander Eikelenboom wrote:

>> Today i tried linuses tree of today (last commit is 4c4d285ad5665bfbd983b95fde8d7a477d24a361).
>>
>> It boots dom0 fine, but it fails to start any domU with: "Error: Failed to query current memory allocation of dom0."
>> With my previous 3.1.5 kernel everything is fine, nothing else changed in config in between.
> Your patch that converts the xen-balloon to use the regular device bus driver
> (070680218379e15c1901f4bf21b98e3cbf12b527) has some not-so-happy consequences.
>
> The toolstack (xen-tools) use:
>
> /sys/devices/system/xen_memory/xen_memory0
>
> But with the change, it is now:
>
> /sys/devices/xen_memory0/target_kb

Urks, seems like a mistake on my side.

Please try if changing:
  bus_unregister(&balloon_subsys);
to:
  subsys_system_register(&balloon_subsys, NULL);
in:
  drivers/xen/xen-balloon.c
fixes the issue.

Sorry for that,
Kay
