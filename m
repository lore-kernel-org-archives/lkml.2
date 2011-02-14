Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1BNMOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 07:14:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60387 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1BNMOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 07:14:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
Subject: Re: [PATCH v4 1/3]mmc: set max_discard_sectors value for mmc queue
Date: Mon, 14 Feb 2011 13:13:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "adrian.hunter@nokia.com" <adrian.hunter@nokia.com>
References: <20110212062214.GB25519@intel.com> <201102121904.30944.arnd@arndb.de> <5D8008F58939784290FAB48F5497519835964E1F58@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <5D8008F58939784290FAB48F5497519835964E1F58@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102141313.52132.arnd@arndb.de>
X-Provags-ID: V02:K0:cMW2a7oPhQ3N/feLlRSy7q7VkP/kZmNzvTw1z5p3FgZ
 eJDQE0NMQ/88FNpoaOr6V9dVx7eNIUm+K/5eXZqobWWSYAScfJ
 gdXlG3ZFOEnKrdPsVtWoVTj6fkkxSunTNQbR+rBZ53AXeDiUXb
 xjomL7BISbmRJTR8q7VIIwaIofps+c9gzTmTxCDQWxiGA37VKM
 n+LWiRHoZ86DYG6Nm7Z+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 February 2011, Dong, Chuanxiao wrote:
> When I do trim with a 32GB eMMC card in my platform, sometimes I can get the 10s
> timeout errors but sometimes not. I am not much clear about the "discarding partial
> AU will take a lot longer". If this action is hide for driver, then I think from 
> driver side, the UINT_MAX value for max_discard_sectors will be OK. But if this action
> sometimes need driver to wait for some hardware interrupt, then I think the UINT_MAX
> value is not preferred.
>
> Arnd, have any suggestion of dealing this? What I thought is using other value
> instead of using UINT_MAX.

I'm not too familiar with the eMMC spec, but it should have a way to calculate
a maximum trim timeout like SD 3.0 does for AU erases. When I've seen the timeouts
with SDHCI (missing your patch), it was always a bug in the driver, and the
erase was already completed before the driver even started waiting for the
interrupt.

10 seconds still sounds like a reasonable timeout, and we should probably
not issue any requests that might take longer than that, so I think the
interesting question is how to determine a good value for pref_erase,
so we can still take your patch.

	Arnd
