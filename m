Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab1IEQSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 12:18:41 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:39253 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750794Ab1IEQSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 12:18:35 -0400
Message-ID: <4E64F656.3040009@metafoo.de>
Date: Mon, 05 Sep 2011 18:18:30 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 4/6] regmap: Add the LZO cache support
References: <1315230662-12401-1-git-send-email-dp@opensource.wolfsonmicro.com> <1315230662-12401-5-git-send-email-dp@opensource.wolfsonmicro.com>
In-Reply-To: <1315230662-12401-5-git-send-email-dp@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2011 03:51 PM, Dimitris Papastamos wrote:
> This patch adds support for LZO compression when storing the register
> cache.
> 
> For a typical device whose register map would normally occupy 25kB or 50kB
> by using the LZO compression technique, one can get down to ~5-7kB.  There
> might be a performance penalty associated with each individual read/write
> due to decompressing/compressing the underlying cache, however that should not
> be noticeable.  These memory benefits depend on whether the target architecture
> can get rid of the memory occupied by the original register defaults cache
> which is marked as __devinitconst.  Nevertheless there will be some memory
> gain even if the target architecture can't get rid of the original register
> map, this should be around ~30-32kB instead of 50kB.
> 
> Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> ---
>  drivers/base/regmap/Makefile       |    2 +-
>  drivers/base/regmap/internal.h     |    2 +
>  drivers/base/regmap/regcache-lzo.c |  361 ++++++++++++++++++++++++++++++++++++
>  drivers/base/regmap/regcache.c     |    1 +
>  include/linux/regmap.h             |    1 +
>  5 files changed, 366 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/base/regmap/regcache-lzo.c
> 

Fails to compile due to CONFIG_LZO_{COMPRESS,DECOMPRESS} not being selected.
Also it will have issues, with caches where we don't use raw cache defaults.
