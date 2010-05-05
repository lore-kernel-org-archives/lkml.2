Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab0EEFSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 01:18:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46290 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab0EEFSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 01:18:41 -0400
MIME-Version: 1.0
In-Reply-To: <p2n9a158e2e1005032230u2cb21e6do40ae0b58e746b75f@mail.gmail.com>
References: <p2n9a158e2e1005032230u2cb21e6do40ae0b58e746b75f@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 5 May 2010 07:18:24 +0200
Message-ID: <q2sac3eb2511005042218x3e858d39j3af0862f884406d3@mail.gmail.com>
Subject: Re: race condition between udevd and modprobe (mtrr_add)
To: Kyle Hubert <khubert@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 07:30, Kyle Hubert <khubert@gmail.com> wrote:
> Hi, while booting an initrd image built off of BusyBox on a thousand
> nodes, we hit a race on a couple of nodes. They hang during the boot
> process with the stack traces listed below. The really simple init
> script in the initrd does a 'udevd --daemon' and then modprobe of a
> device. The device needs to assign an mtrr to the pci resource, and
> instead the whole node hangs. Putting a 'sleep 1' in between these two
> calls prevents any hangs.
>
> mtrr_add_page and the buddy allocator code don't appear to share any
> semaphores, and there isn't an obvious way in which this can hang.
> Possibly the smp_call_function IPI isn't being handled by the other
> cores... That's the best guess. Can anyone help sort this mess out?
>
> Also, is there a better way to test that udevd is fully up? A 'sleep
> 1' is not the preferred solution here.

"udevadm settle" might do it.

Kay
