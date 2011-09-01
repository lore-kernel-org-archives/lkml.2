Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628Ab1IAQQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:16:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612Ab1IAQQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:16:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 4/4] dynamic_debug: fix undefined reference to `__netdev_printk'
Date: Thu, 1 Sep 2011 18:16:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
References: <cover.1314725877.git.jbaron@redhat.com> <bb1973868f9af8673cffdb5c77c590396d17554e.1314725877.git.jbaron@redhat.com>
In-Reply-To: <bb1973868f9af8673cffdb5c77c590396d17554e.1314725877.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109011816.39274.arnd@arndb.de>
X-Provags-ID: V02:K0:zsw4b7hVm5pb1bwMuzz1GEQlKQCteKbD60nMsIXTT6U
 I+Hk674Qot0tE97PlGhLB4SBItFy7NfO0SzTsGoh2N+SjXrJHm
 2mt4Hg1eGMS8zJkp7LcwIIBO5kBdDO26vgcqayiqnLS2tzmxqr
 Z9kAjHJOR8XNrHsk6jb5ze0/sHMxvXZAYbUUJvwBcsdHOOZwA3
 8ytHO2cLe/rZ4OahSnWCdlrSHDx75rQdq4IxJTnyjM364pU9wa
 hYWERvjd2BtdEpA32GINZR8BFoMhq6ADCe7A+rhLGmbN3gcSPq
 qDQKgFEonNDiqUx1kN4Ab+9wX1cT/4yrRqoOpzkXP9A2SphZep
 UReKZyM1J1cOGVk4Ha9Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Jason Baron wrote:
> 
> Dynamic debug recently added support for netdev_printk. It uses
> __netdev_printk() to support this functionality. However, when
> CONFIG_NET is not set, we get the following error:
> 
> lib/built-in.o: In function `__dynamic_netdev_dbg':
> (.text+0x9fda): undefined reference to `__netdev_printk'
> 
> Fix this by making the call to netdev_printk() contingent upon
> CONFIG_NET. We could have fixed this by defining netdev_printk()
> to a 'no-op' in the !CONFIG_NET case. However, this is not
> consistent with how the networking layer uses netdev_printk.
> For example, CONFIG_NET is not set, netdev_printk() does not
> have a 'no-op' definition defined.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Found it too, came up with the same fix

Acked-by: Arnd Bergmann <arnd@arndb.de>
