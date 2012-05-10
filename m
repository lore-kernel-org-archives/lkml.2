Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2EJIYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:24:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42417 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab2EJIYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:24:30 -0400
MIME-Version: 1.0
In-Reply-To: <201205091756.16050.arnd@arndb.de>
References: <CAMP44s2eVtquLoB6Zjbs4nGVKP6e=Dxse4uicL4s8vmrFeJdTQ@mail.gmail.com>
	<201205091756.16050.arnd@arndb.de>
Date: Thu, 10 May 2012 10:24:28 +0200
Message-ID: <CAMP44s0u3-=umxue1Oo=1C1MnQ8AbWeL2P3N_S8A5BK4NRwX2w@mail.gmail.com>
Subject: Re: Big I/O latencies, except when iotop is hooked
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 7:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> The first thing you should check is whether the partitions are
> properly aligned, using 'fdisk -l -u /dev/sdX'.

I aligned it to 4MiB, it doesn't make much of a difference.

> Of course none of this will tell you why iotop makes any difference.

After trying a bit more I can still see the problem with iotop, I
could swear it happens much less often, but I can't really be sure
now.

I tried with different io schedulers, and it seems cfq does better, I
also tried different priorities, but the issue was still there.

I also tried to setup the crypto partition with align-payload, to no
avail, and to get rid of crypto altogether. I also tried with multiple
ext4 format options, but they seemed to make matters worst.

I finally tried on a normal disk device, and it works perfectly there
(even with encryption); so the issue happens only on SSD/usb key.

Cheers.

-- 
Felipe Contreras
