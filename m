Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab2JDIXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:23:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54182 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2JDIXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:23:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 07/17] ARM: at91: skip at91_io_desc definition for NOMMU
Date: Thu, 4 Oct 2012 08:23:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <1349195816-2225-8-git-send-email-arnd@arndb.de> <20121002185651.GC5117@game.jcrosoft.org>
In-Reply-To: <20121002185651.GC5117@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210040823.16315.arnd@arndb.de>
X-Provags-ID: V02:K0:bdeoyWcjdjo4b11byN9RDNJMvZLeycY1hgA8CQwrzkp
 am9FdXtmOytn6q7DOhbP27Rm4cxLi5htoP5+CtGFWUAz8TabfZ
 vh+dB0IuACgt4cHGwsiFOH0hxaMCi7bI1lAld7sDfSpfb8Tm6d
 Q9L21NebBAEyfxTi8TK+a+1oWKMfo4Co1z4AGPE8MHOyXsb90o
 zuZdQ1W0N17A3fdRjD4lMmvafFwK9m+UdA19oKYaZy084RRU7r
 xQ4eGQduIj6eCjP4JOraO4caP4RwtF8BncUcUJzr1/g4v1074/
 XpWVJtV/FGGqrQOiQvxng3bzewT9pQ5IvlScLgAedJuHaO62N/
 YL1r5MjZae/f95zEc24Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 October 2012, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 18:36 Tue 02 Oct     , Arnd Bergmann wrote:
> > On NOMMU systems, we do cannot remap the MMIO space, so the
> > definition of at91_io_desc is unused.
> > 
> > Without this patch, building at91x40_defconfig results in:
> > 
> > arch/arm/mach-at91/setup.c:90:24: warning: 'at91_io_desc' defined but not used [-Wunused-variable]
> I prefer a __maybe_unused on the struct so the compilator will just drop it
> 

Ok, makes sense. I've fixed up the patch accordingly.

	Arnd
