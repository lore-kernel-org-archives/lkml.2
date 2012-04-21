Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab2DUVLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 17:11:38 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:53355 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2DUVLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 17:11:37 -0400
MIME-Version: 1.0
In-Reply-To: <4F931C6D.8040407@molgaard.org>
References: <4F931C6D.8040407@molgaard.org>
Date: Sat, 21 Apr 2012 14:11:36 -0700
X-Google-Sender-Auth: qIeyUQwYYcO5vLEN6ANw7XhWDRU
Message-ID: <CAE9FiQVSWSNt6MVGU6MiHozpcbjyzukvM++E5kEv5BSsS-nbzw@mail.gmail.com>
Subject: Re: Boot failure since 3.3-rc?
From: Yinghai Lu <yinghai@kernel.org>
To: =?ISO-8859-1?Q?Sune_M=F8lgaard?= <sune@molgaard.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 1:45 PM, Sune Mølgaard <sune@molgaard.org> wrote:
> Hiya,
>
> My old AMD Duron system (i386 with 2G RAM) has been unable to boot recent
> kernels, and I have bisected it down to:
>
> commit 321bf4ed5ff5f7c62ef59f33b7eec5b154391f0a
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Mon Jan 30 13:57:12 2012 -0800
>
>    drivers/base/memory.c: fix memory_dev_init() long delay
>
>    One system with 2048g ram, reported soft lockup on recent kernel.
>
> [snip the trace of the bug that this should fix]
>
>    Finally it takes about 55s to create 16400 memory entries.
>
>    Root cause: for x86_64, 2048g (with 2g hole at [2g,4g), and TOP2 will be
> 2050g), will have 16400 memory block.
>
>    find_memory_block/subsys_find_device_by_id will be expensive with that
> many entries.
>
>    Actually, we don't need to find that memory block for BOOT path.
>
>    Skip that finding make it get back to normal.
>
>    [   34.466696] cpu_dev_init done
>    [   35.290080] memory_dev_init done
>
>    Also solved the delay with topology_init when sections_per_block is not
> 1.
>
>    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>    Cc: Kay Sievers <kay.sievers@vrfy.org>
>    Cc: Nathan Fontenot <nfont@austin.ibm.com>
>    Cc: Robin Holt <holt@sgi.com>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> :040000 040000 95174f8192a2303d9e59e5f8523a58780b828e3e
> 2de57c6dc44872ac11766616f1cf05d6070b60de M      drivers
>
> Will be happy to test patches, but compilation is obviously slow on this
> machine, so some delay might occur.

So kernel with reverting that commit will work well?

can you post boot with "debug ignore_loglevel initcall_debug" with and
without reverting that patch?

Thanks

Yinghai
