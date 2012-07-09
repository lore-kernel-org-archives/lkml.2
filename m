Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab2GIPc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:32:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51753 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2GIPcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:32:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Date: Mon, 9 Jul 2012 15:32:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <20120709113558.GE8052@arm.com> <20120709145126.313d1574@pyramind.ukuu.org.uk>
In-Reply-To: <20120709145126.313d1574@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207091532.12256.arnd@arndb.de>
X-Provags-ID: V02:K0:K1DVjQKzjbVttMR0Fxsrp/f8Fiiy/XhceR9rm/lUC7U
 62Uub4YQQcpC6iGC5XLC35P+R2ZWHyA4SwJryuUG9z7mcg7UqY
 HluBH5CU5m/xSwxMsiu4Q7E/LUx4llMhXBfA2Isnk1AGcTNHzr
 3TDpHOlAjPjDy7u3HJFiwO5B7sX+5ocg4j95Ep7znBJtCJn+pP
 YYZflCmVZ82tUaoU3YYkcyvpytsT5s9lTJoyUuTD72UFhc9ert
 0l1q0cPBKPjtkPia5slgbZwgIEpkbR9LiYNad4MSb19kpJPsmw
 v1yNqtltrCML0XqJ8+gjpDV51SVkjuhOoDfoD1OA3/1IdONpZK
 wgDavIJdoL+T2/Ots0+8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2012, Alan Cox wrote:
> > > These are the same reasons the x86_64 people gave and regretted later.
> > 
> > I would not compare the x86_64 extension to the AArch64 architecture.
> 
> 
> It's not an architecture specific observation. I was just observing that
> you were following a pattern which in all other cases ended up with a
> merged tree.

All except ia64, which is probably considered a good thing nowadays,
even though there is still a significant amount of shared code between
ia64 and x86.

In case of sh64, my feeling is that the fact that it's now is more
a burden than a benefit, given that all relevant arch/sh systems
are the 32 bit variant.

Another interesting example is unicore32, which actually shares more
code with arch/arm than the proposed arch/aarch64 does. I think the
unicore32 code base would benefit from being merged back into arch/arm
as a third instruction set, but the additional maintainance cost for
everyone working on ARM makes that unrealistic.

> Now it could be your tree is different, it could be that the right
> approach in all these cases is actually to do a new tree and merge five
> years later - I don't know.

It's always a tradeoff. Right now I think it's better for both arm
and aarch64 to live as separate architectures, and it will remain that
way for a number of years. Some people suggested that we might want to
keep the two split initially but add support for the "modern" 32 bit
platforms in a mixed 32/64 arch/aarch directory like we did for
powerpc, but I'm rather skeptical about that. On powerpc, that resulted
in a cleaner end result than doing the merge first would have, but
it was also a long and painful process.
It's good to know that we have the option though, in case we decide
to merge in a few years after all.

> It's your (aarch64 folks) project at the end of the day and you who have
> to keep all the fixes and errata and whatnot in sync between the two
> trees and I don't personally care too much which way it happens.

We have a lot of reviewers that are familiar with the 32 bit code, so
I think the main strategy should be to spot duplicate code early
and make sure we deal with it individually. Examples for this are
probably the implementations for kvm and perf, which largely deal
with the same hardware on both architectures. Those definitely must
not get duplicated into mostly-identical files. In many cases, we're
moving those things into drivers/*, in other cases we might want to
use Makefile logic to include a sub-directory from one arch into another,
as we do for arch/um.

	Arnd
