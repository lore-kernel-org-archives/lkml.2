Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab2AWPoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:44:19 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42294 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2AWPoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:44:18 -0500
MIME-Version: 1.0
From: Sagar Borikar <sagar.borikar@gmail.com>
Date: Mon, 23 Jan 2012 07:43:56 -0800
Message-ID: <CAFwMWxs7S+6VqA00NFVKum=QHU2266Mj2kXcoHzRfyXU8+dv7A@mail.gmail.com>
Subject: mmap locked doesn't return
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


We are observing that mmap when called with MAP_SHARED and MAP_LOCKED
flags on the disk which has the bad sectors, doesn't return either
success or failure and gets stuck somewhere in mmap routine. Disk
replacement is the obvious solution but the question is what makes
mmap not to return failure?
Individual mapping works fine i.e. on the same disk at same offset
when mmap is invoked with MAP_SHARED or MAP_LOCKED the call succeeds
but when they both are clubbed together, it doesn't return anything.

strace output snippet

open("/dev/dm-4p2", O_RDWR)             = 3
mmap(NULL, 10485760, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_LOCKED, 3, 0x4000000


setup:

2.6.23 LST kernel
Westmere platform - 4 socket cpu
RAM -192GB


Thanks
Sagar
