Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab1CPFRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 01:17:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49805 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1CPFRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 01:17:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vPCIZ77wcoQH09YIn+7t8TbTxX2D6m6Gg7sMtVPeqcX3tpWIprhSNctPS/1KSIxq10
         9G8V4gVdjLbSPkJcDrrXk3XmREteclXTvVyzmKP0RpxhcwuMPBX4JFpkq4EfOoQ4e6rH
         YIII5WntwyxGD1x7gcN/d+k8GvJ9GbMJ3Ddk8=
MIME-Version: 1.0
In-Reply-To: <87d3lriv7e.fsf@rustcorp.com.au>
References: <20110310070541.27327.52089.sendpatchset@t400s>
	<87d3lriv7e.fsf@rustcorp.com.au>
Date: Wed, 16 Mar 2011 14:17:15 +0900
Message-ID: <AANLkTi=zjGubKx0vV+hqEYiVFVNTAEoGwxEfL4oprxk8@mail.gmail.com>
Subject: Re: [PATCH 00/02] virtio: Virtio platform driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        linux-s390@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Wed, Mar 16, 2011 at 12:46 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thu, 10 Mar 2011 16:05:41 +0900, Magnus Damm <magnus.damm@gmail.com> wrote:
>> virtio: Virtio platform driver
>>
>> [PATCH 01/02] virtio: Break out lguest virtio code to virtio_lguest.c
>> [PATCH 02/02] virtio: Add virtio platform driver
>
> I have no problem with these patches, but it's just churn until we see
> your actual drivers.

Well, actually this platform driver is used together with already
existing drivers, so there are no new virtio drivers to wait for.

The drivers that have been tested are so far:

CONFIG_VIRTIO_CONSOLE=y
CONFIG_VIRTIO_NET=y

At this point there are four different pieces of code working together

1) Virtio platform driver patches (for guest)
2) SH4AL-DSP guest kernel patch
3) ARM UIO driver patches (for host)
4) User space backing code for ARM based on lguest.c

These patches in this mail thread are 1), and I decided to brush up
that portion and submit upstream because it's the part that is easiest
to break out. I intend to post the rest bit by bit over time, but if
someone is interested then I can post everything at once too.

> The S/390 devs might be interested, as their bus is very similar too...

The lguest device code is very similar as well, perhaps it's worth
refactoring that a bit to build on top of the platform driver. Not
sure if you see that as a move in the right direction though.

Thanks for your feedback!

/ magnus
