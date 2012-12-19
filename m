Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab2LSNwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:52:31 -0500
Received: from defer-dn03.ocn.ad.jp ([125.170.100.156]:35149 "EHLO
	defer-dn03.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2LSNwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:52:23 -0500
X-Greylist: delayed 2285 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 08:52:22 EST
Date: Wed, 19 Dec 2012 22:12:40 +0900 (JST)
Message-Id: <20121219.221240.129782578.anemo@mba.ocn.ne.jp>
To: axel.lin@ingics.com
Cc: akpm@linux-foundation.org, a.zummo@towertech.it,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: tx4939: Kill get_tx4939rtc_plat_data() function
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1355909344.11204.3.camel@phoenix>
References: <1355909344.11204.3.camel@phoenix>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net:11371/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 17:29:04 +0800, Axel Lin <axel.lin@ingics.com> wrote:
> Simply use dev_get_drvdata() instead.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/rtc/rtc-tx4939.c |   21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)

Hi Axel,

Thank you for cleanup, but, a platform driver should use
platform_get_drvdata / platform_set_drvdata, no?

I think using dev_get_drvdata() in platform_get_drvdata() is an
implementation detail of the platform device framework, so we should
not depends on such an internal detail.

If there was any reason to use dev_get_drvdata, please convert all
platform_get_drvdata and platform_set_drvdata to dev_get_drvdata and
dev_set_drvdata.  We should avoid mixing two APIs.

---
Atsushi Nemoto
