Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab2BGAgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:36:08 -0500
Received: from defer-dn01.ocn.ad.jp ([125.170.100.155]:51454 "EHLO
	defer-dn01.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2BGAgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:36:06 -0500
X-Greylist: delayed 1079 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Feb 2012 19:36:06 EST
Date: Tue, 07 Feb 2012 09:16:12 +0900 (JST)
Message-Id: <20120207.091612.181444339.anemo@mba.ocn.ne.jp>
To: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: kconfig: tristate choice with depender choice
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net:11371/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a tristate choice has another choice dependers, kconfig produce
wrong value.

Example:

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

kconfig outputs CONFIG_A=m from defconfig with CONFIG_A=y.

This happens if the choice list CD depends on A.
Also, if defconfig contains CONFIG_A=y and "# CONFIG_B is not set",
output is correct.

I found commit a64b44ea ("kconfig: fix tristate choice with minimal
config"), but this problem still exists on v3.3-rc1.  More fix is
needed for choice with dependers?

---
Atsushi Nemoto
