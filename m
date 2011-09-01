Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab1IAP2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 11:28:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57498 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab1IAP2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 11:28:22 -0400
MIME-Version: 1.0
X-Originating-IP: [87.66.92.201]
In-Reply-To: <201108310017.03103.rjw@sisk.pl>
References: <201108310017.03103.rjw@sisk.pl>
Date: Thu, 1 Sep 2011 17:28:20 +0200
Message-ID: <CAORVsuVJEbLRXLuQFUh3_rDf+DfNFpOhEuBr33SRKqxBos=6Bw@mail.gmail.com>
Subject: Re: [PATCH 0/5] PM: Generic PM domains and device PM QoS
From: Jean Pihet <jean.pihet@newoldbits.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Wed, Aug 31, 2011 at 12:17 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> This patchset illustrates how device PM QoS may be used along with
> PM domains in my view.
>
> Actually, it consists of two parts.  Namely, patches [1-3/5] seem to be
> suitable for 3.2, unless somebody hates them,
The patches [1-3/5] are ok (reviewed only) excepted some remarks I have.

> but patches [4-5/5] are
> total RFC.  They haven't been tested, only compiled, so the use of them
> is not encouraged (they may kill your dog or make your cat go wild, or
> do something equally nasty, so beware).
That looks like a disclaimer ;p

> Their purpose is to illustrate
> an idea that I'd like to discuss at the PM miniconference during the
> LPC.
There is some code for OMAP that dynamically updates the worst case
values for devices activation and de-activation;
cf._omap_device_activate and _omap_device_deactivate in
arch/arm/plat-omap/omap_device.c. The idea is to start with reference
figures (worst case measured on board) at boot and then update the
worst case values at runtime.
Based on the PM QoS values and the worst case latency values the next
power domains states can be determined. Unfortunately this is not
(yet) implemented.

I am wondering if the patches [4-5/5] are meant to replace the OMAP
code, which would be really nice.

>
> [1/5] - Split device PM domain data into a "base" and additional fields
>        (one need_restore field at the moment, but the subsequent patches
>        add more fields).
>
> [2/5] - Make runtime PM always release power.lock if power.irq_safe is set.
>
> [3/5] - Add function for reading device PM QoS values safely.
>
> [4/5] - Add governor function for stopping devices.
>
> [5/5] - Add generic PM domain power off governor function.
>
> Thanks,
> Rafael
>
>

Regards,
Jean
