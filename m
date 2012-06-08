Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2FHFOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:14:22 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:57100 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761509Ab2FHFOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:14:16 -0400
X-IronPort-AV: E=Sophos;i="4.75,734,1330902000"; 
   d="scan'208,223";a="161856950"
Date: Fri, 8 Jun 2012 07:14:03 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: David Miller <davem@davemloft.net>
cc: kernel-janitors@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH 1/7] drivers/ide/ide-cs.c: adjust suspicious bit
 operation
In-Reply-To: <20120607.144616.2224976714259476349.davem@davemloft.net>
Message-ID: <alpine.DEB.2.02.1206080712510.1793@hadrien>
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr> <1339018901-28439-2-git-send-email-Julia.Lawall@lip6.fr> <20120607.144616.2224976714259476349.davem@davemloft.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From nobody Wed Jun  6 21:48:37 CEST 2012
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org,linux-kernel@vger.kernel.org,joe@perches.com
Subject: [PATCH 1/7] drivers/ide/ide-cs.c: adjust suspicious bit operation

From: Julia Lawall <Julia.Lawall@lip6.fr>

IO_DATA_PATH_WIDTH_8 is 0, so a bit-and with it is always false.  The
value IO_DATA_PATH_WIDTH covers the bits of the IO_DATA_PATH constants, so
first pick those bits and then make the test using !=.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <julia@diku.dk>

---
  drivers/ide/ide-cs.c |    3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index 28e344e..f1e922e 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -167,7 +167,8 @@ static int pcmcia_check_one_config(struct pcmcia_device *pdev, void *priv_data)
  {
  	int *is_kme = priv_data;

-	if (!(pdev->resource[0]->flags & IO_DATA_PATH_WIDTH_8)) {
+	if ((pdev->resource[0]->flags & IO_DATA_PATH_WIDTH)
+	    != IO_DATA_PATH_WIDTH_8) {
  		pdev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
  		pdev->resource[0]->flags |= IO_DATA_PATH_WIDTH_AUTO;
  	}
