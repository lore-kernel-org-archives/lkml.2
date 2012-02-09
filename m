Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab2BIOb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:31:57 -0500
Received: from defer-dn01.ocn.ad.jp ([125.170.100.155]:39547 "EHLO
	defer-dn01.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab2BIOb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:31:56 -0500
Date: Thu, 09 Feb 2012 23:30:17 +0900 (JST)
Message-Id: <20120209.233017.47225051.anemo@mba.ocn.ne.jp>
To: lacombar@gmail.com
Cc: mmarek@suse.cz, sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: kconfig: tristate choice with depender choice
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <CACqU3MU6j0ed6C9QDfzuoH+2a-2hww2wrCsQXW-kUfK37iansQ@mail.gmail.com>
References: <20120207.091612.181444339.anemo@mba.ocn.ne.jp>
	<CACqU3MXdKti6J2ozx3mt3UHdhv1fyPredvT6zJGR+u_hNU70Cg@mail.gmail.com>
	<CACqU3MU6j0ed6C9QDfzuoH+2a-2hww2wrCsQXW-kUfK37iansQ@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net:11371/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012 00:26:25 -0500, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> confirmed.
>>
> actually, not that much. Your reduced testcase is missing a MODULES
> symbol to have modules enabled and have them show up in the final
> `.config'. If you add:
> 
> config MODULES
>   boolean
>   default y
> 
> then you end up with CONFIG_A=m in the `.config'.

Yes, so it is the problem.  I got CONFIG_A=m in .config from
CONFIG_A=y in defconfig.

> Now, I may have missed something.
> 
> Do you have a situation where a MODULES symbol is present, enabled,
> but CONFIG_A=y still appear from CONFIG_A=m in the defconfig ?

I tested in this way:

1. Add this example to the end of drivers/char/Kconfig file.
-------------------------------------
choice
	prompt "choice list AB"
config A
	tristate "a"
config B
	tristate "b"
endchoice
choice
	prompt "choice list CD"
	depends on A
config C
       	bool "c"
config D
       	bool "d"
endchoice
-------------------------------------

2. Then run commands:

$ cp arch/x86/configs/i386_defconfig arch/x86/configs/test_defconfig
$ echo 'CONFIG_A=y' >> arch/x86/configs/test_defconfig 
$ make O=../build test_defconfig
$ grep CONFIG_A= ../build/.config
CONFIG_A=m

---
Atsushi Nemoto
