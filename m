Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1AZUiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:38:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53725 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab1AZUiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:38:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=PpQtwm4WpaTQQtnkG3KKQp/oRldA3bA+TMggvhyBNhwOYFweKi4xQY0yAhB1TI+3v/
         f3N191ogM/aVctn//jzRvPsHYaDtaYT6zdy0V9PrCzih9WhTIOyhCErkBjAcrfhKpQU/
         gJbfWn5OHEOozlMtjEN8ymr2jDpomC4ljSz4s=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Rob Landley <rlandley@parallels.com>
Subject: Re: 2.6.37 says WARNING: at arch/x86/kernel/apic/apic.c:1287 setup_local_APIC+0x18f/0x263()
Date: Wed, 26 Jan 2011 21:21:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4D359188.3040408@parallels.com>
In-Reply-To: <4D359188.3040408@parallels.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101262121.41405.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=27642
for your bug report, please add your address to the CC list in there, thanks!
On wtorek, 18 stycznia 2011 o 14:11:36 Rob Landley wrote:
> Booting an x86-64 2.6.37 kernel under QEMU with the attached .config and
> this  qemu command line:
> 
>   qemu-system-x86_64 -nographic -no-reboot -kernel "zImage-x86_64" \
>     -hda "image-x86_64.sqf" -append \
>     "root=/dev/hda rw init=/sbin/init.sh panic=1 PATH=/bin:/sbin
> console=ttyS0 HOST=x86_64"
> 
> It said this during boot:
> 
> CPU: AMD QEMU Virtual CPU version 0.13.50 stepping 03
> Setting APIC routing to flat
> ------------[ cut here ]------------
> WARNING: at arch/x86/kernel/apic/apic.c:1287 setup_local_APIC+0x18f/0x263()
> Hardware name: Bochs
> Pid: 1, comm: swapper Not tainted 2.6.37 #1
> Call Trace:
>  [<ffffffff812dc36d>] ? setup_local_APIC+0x18f/0x263
>  [<ffffffff8101c86b>] ? warn_slowpath_common+0x73/0x88
>  [<ffffffff812dc36d>] ? setup_local_APIC+0x18f/0x263
>  [<ffffffff812c6155>] ? APIC_init_uniprocessor+0x99/0x109
>  [<ffffffff812bf886>] ? kernel_init+0x5e/0x122
>  [<ffffffff81002694>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff812bf828>] ? kernel_init+0x0/0x122
>  [<ffffffff81002690>] ? kernel_thread_helper+0x0/0x10
> ---[ end trace 4eaa2a86a8e2da22 ]---
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> devtmpfs: initialized
> 
> And so on.  Seems to have booted fine, but I thought you'd like to know
> and I couldn't find a mention of this in the January lkml archive...
> 
> Rob

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
