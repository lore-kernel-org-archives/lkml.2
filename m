Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2GPJto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:49:44 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:38525 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab2GPJtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:49:41 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2012 05:49:41 EDT
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGohdvpEkce+Ub40Q/uAFj+9EbzQUD+D2YGO
X-RZG-CLASS-ID: mo05
From: Stefan Roese <sr@denx.de>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [PATCH] drivers/mtd/devices/spear_smi.c: failure test for null rather than negative integer
Date: Mon, 16 Jul 2012 11:38:19 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-15-generic; KDE/4.7.2; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1341997118-25042-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1341997118-25042-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207161138.19985.sr@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2012 10:58:38 Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> dev_get_platdata returns a pointer, so the failure value would be NULL
> rather than a negative integer.
> 
> The semantic match that finds this problem is: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,e;
> statement S1,S2;
> @@
> 
> *x = dev_get_platdata(...)
> ... when != x = e
> *if (x < 0) S1 else S2
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Stefan Roese <sr@denx.de>
 
Thanks,
Stefan
