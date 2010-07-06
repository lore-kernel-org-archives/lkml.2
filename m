Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0GFRfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 13:35:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46121 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0GFRfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 13:35:50 -0400
Date: Tue, 6 Jul 2010 10:34:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 6 (NET_DSA + PHYLIB kconfig)
Message-Id: <20100706103417.8923b697.randy.dunlap@oracle.com>
In-Reply-To: <20100706190519.93d8b785.sfr@canb.auug.org.au>
References: <20100706190519.93d8b785.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C336970.012A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jul 2010 19:05:19 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100705:
> 
> My fixes tree contains:
> 	kbuild: Fix path to scripts/setlocalversion
> 
> ----------------------------------------------------------------------------

kconfig now detects symbol dependency errors and warns about them.
E.g.:

warning: (NET_DSA && NET && EXPERIMENTAL && !S390 || MACB && NETDEVICES && NET_ETHERNET && (AVR32 || ARCH_AT91SAM9260 || ARCH_AT91SAM9263 || ARCH_AT91SAM9G20 || ARCH_AT91SAM9G45 || ARCH_AT91CAP9) || IXP4XX_ETH && NETDEVICES && NET_ETHERNET && ARM && ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR || W90P910_ETH && NETDEVICES && NET_ETHERNET && ARM && ARCH_W90X900 || MIPS_AU1X00_ENET && NETDEVICES && NET_ETHERNET && SOC_AU1X00 || SH_ETH && NETDEVICES && NET_ETHERNET && SUPERH && (CPU_SUBTYPE_SH7710 {{20 lines deleted}}
selects PHYLIB which has unmet direct dependencies (!S390 && NET_ETHERNET)

says that NET_DSA & PHYLIB have some kind of problem.
NET_DSA selects PHYLIB.  PHYLIB depends on NET_ETHERNET, which is not enabled
in this randconfig.  net/dsa code does need PHYLIB code, so PHYLIB symbol should
either drop "depends on NET_ETHERNET" or it should be changed to
	depends on NET_ETHERNET || NET_DSA

Preference?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
