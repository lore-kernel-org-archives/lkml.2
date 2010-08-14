Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab0HNGgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 02:36:32 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56040 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab0HNGgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 02:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:content-type;
        b=onJ5t6Nl8ibJdv9xdTAFLPv+fdwB0Nm2+0+tCua11eFxioVvwdPLGpOTunUDekcLBU
         Teol9Ge9hVWqRKG/YBuk/gq1lt7l6OLAtZgC5nupmrziMe5yY5NS7zuHZIYlAXH4D6t3
         UAk0lbkNRilNFDQTPoNpOnPnS6UWDso9iIWh4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTi=YL_VKKDU8ok=OYotPhyQcGsVB2O-PU29+70YT@mail.gmail.com>
References: <AANLkTi=YL_VKKDU8ok=OYotPhyQcGsVB2O-PU29+70YT@mail.gmail.com>
Date: Sat, 14 Aug 2010 08:36:30 +0200
Message-ID: <AANLkTikP3FHZ0f7umRRzXcT1ytfa9XfE41UHmQ98kO2h@mail.gmail.com>
Subject: Re: Call traces w/ 2.6.35.2 (not w/ 2.6.35.1 plus 2.6.35.2-rc1)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hope this helps to give an overview what has changed:

$ grep "diff --git" patch-2.6.35.2 | sort > list.patch-2.6.35.2
$ grep "diff --git" new.patch | sort > list.patch-2.6.35.1+patch-2.6.35.2-rc1


$ diff -Naur list.patch-2.6.35.2
list.patch-2.6.35.1+patch-2.6.35.2-rc1 | grep ^+diff
+diff --git a/arch/arm/plat-mxc/include/mach/gpio.h
b/arch/arm/plat-mxc/include/mach/gpio.h
+diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
+diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
+diff --git a/fs/block_dev.c b/fs/block_dev.c
+diff --git a/include/linux/notifier.h b/include/linux/notifier.h
+diff --git a/Makefile b/Makefile

$ diff -Naur list.patch-2.6.35.2
list.patch-2.6.35.1+patch-2.6.35.2-rc1 | grep ^-diff
-diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
-diff --git a/mm/memory.c b/mm/memory.c

$ ls -l list.patch-2.6.35.*
-rw-r--r-- 1 sd sd 9004 14. Aug 08:32 list.patch-2.6.35.1+patch-2.6.35.2-rc1
-rw-r--r-- 1 sd sd 8724 14. Aug 08:32 list.patch-2.6.35.2

- Sedat -

On Sat, Aug 14, 2010 at 8:20 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi Greg,
>
> looks like 2.6.35.2 misses some fixes from 2.6.35.2-rc1?
>
> sd@tbox:~/src/linux-2.6/patches/upstream$ cat patch-2.6.35.1
> patch-2.6.35.2-rc1 > new.patch
>
> sd@tbox:~/src/linux-2.6/patches/upstream$ grep "diff --git" new.patch | wc -l
> 132
>
> sd@tbox:~/src/linux-2.6/patches/upstream$ grep "diff --git"
> patch-2.6.35.2 | wc -l
> 128
>
> Unfortunately, a kernel patched w/ 2.6.35.2 causes Call traces here.
>
> Attached are dmeg outputs for both kernels.
>
>
> Kind Regards,
> - Sedat -
>
