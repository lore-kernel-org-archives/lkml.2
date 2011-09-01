Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab1IAOlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:41:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:63626 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634Ab1IAOlX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:41:23 -0400
MIME-Version: 1.0
Message-ID: <0751ecab-e45d-4984-beff-1f74cabbd8db@default>
Date: Thu, 1 Sep 2011 07:41:12 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: RE: zcache - trivial tweak to build-time error message wording
References: <54715.1314822196@turing-police.cc.vt.edu>
In-Reply-To: <54715.1314822196@turing-police.cc.vt.edu>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020202.4E5F9992.0230:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
> Sent: Wednesday, August 31, 2011 2:23 PM
> To: Dan Magenheimer
> Cc: linux-kernel@vger.kernel.org
> Subject: zcache - trivial tweak to build-time error message wording
> 
> Clarify that the requirement is "at least one of" - the error message could
> potentially be read as both being required.
> 
> Yes, the line is over 80 chars.  You can't get 79 chars of text and a #error
> into 80 chars :)
> 
> Patch against linux-next-20110831
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> 
> --- linux-next/drivers/staging/zcache/zcache-main.c.dist	2011-08-31 13:31:27.054696837 -0400
> +++ linux-next/drivers/staging/zcache/zcache-main.c	2011-08-31 16:16:46.055659964 -0400
> @@ -34,7 +34,7 @@
>  #include "../zram/xvmalloc.h" /* if built in drivers/staging */
> 
>  #if (!defined(CONFIG_CLEANCACHE) && !defined(CONFIG_FRONTSWAP))
> -#error "zcache is useless without CONFIG_CLEANCACHE or CONFIG_FRONTSWAP"
> +#error "zcache is useless without at least one of CONFIG_CLEANCACHE or CONFIG_FRONTSWAP"

Actually, if the reader interprets that both are required,
that's fine with me.  Cleancache and frontswap were split
up for upstreaming purposes but, except in unusual circumstances,
should always be used together.  That is difficult, of course,
if frontswap is not yet merged in your build tree, but after
frontswap is merged in Linus's tree, I might be inclined to
require both CONFIG_CLEANCACHE *and* CONFIG_FRONTSWAP in
the future Kconfig for zcache.
