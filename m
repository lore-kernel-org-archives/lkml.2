Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab1IJCrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 22:47:40 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:41013 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab1IJCrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 22:47:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1109092042540.11756@parag-X220>
References: <alpine.DEB.2.02.1109092042540.11756@parag-X220>
Date: Fri, 9 Sep 2011 19:47:38 -0700
X-Google-Sender-Auth: ubR0y99e1gjq-bai2PAdbqTTVVs
Message-ID: <CAE9FiQX5ZL5LbQtVfbKCvbJoPvkOhvmCtsvEXAJZU1+48R9_WQ@mail.gmail.com>
Subject: Re: MTRR allocation failure
From: Yinghai Lu <yinghai.lu@oracle.com>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 5:54 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>
> I had the below messages in log and not other noticeable slowness.
>
> mtrr: no more MTRRs available
> [drm] MTRR allocation failed.  Graphics performance may suffer.
>
> I was able to pass mtrr_gran_size=128M enable_mtrr_cleanup to kernel
> command line and those messages went away but I lost 143MB of RAM.
>
> I recently did a BIOS upgrade to resolve some other unrelated issues and
> now even with the above command line options the MTRR allocaiton failure
> is back but I don't have any lost RAM - this time too without any
> notieceable slowness. I tried various options for mtrr_gran_size and
> mtrr_spare_reg_nr with no change.
>
> cat /proc/mtrr :
>
> reg00: base=0x0ffc00000 ( 4092MB), size=    4MB, count=1: write-protect
> reg01: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> reg02: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> reg03: base=0x0c0000000 ( 3072MB), size=  512MB, count=1: write-back
> reg04: base=0x0dc000000 ( 3520MB), size=   64MB, count=1: uncachable
> reg05: base=0x0db000000 ( 3504MB), size=   16MB, count=1: uncachable
> reg06: base=0x100000000 ( 4096MB), size= 4096MB, count=1: write-back
> reg07: base=0x200000000 ( 8192MB), size=  512MB, count=1: write-back
> reg08: base=0x21f000000 ( 8688MB), size=   16MB, count=1: uncachable
> reg09: base=0x21e800000 ( 8680MB), size=    8MB, count=1: uncachable
>
> Sounds like some uncachable entries can be merged? I disabled #08, 09, 04
> and 05 with no immediate side effects.
>
> Is there any other option combo I can try to have some free entries for
> X/drm?

your BIOS create one new WP entry. so mtrr sanitizer is not triggered...

Maybe you can just delete first entry before you load drm?

Yinghai
