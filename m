Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1H2L1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 07:27:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58492 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1H2L1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 07:27:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 1/2] arch/powerpc/platforms/cell/iommu.c: add missing of_node_put
Date: Mon, 29 Aug 2011 13:26:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: kernel-janitors@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
References: <1313943001-12884-1-git-send-email-julia@diku.dk>
In-Reply-To: <1313943001-12884-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291326.49561.arnd@arndb.de>
X-Provags-ID: V02:K0:Zordxq6pOcnEomQsTBzJNHJs+oXb6TubYKcnbkOB4Rn
 4NKAJadssKLUmJY10viJfyqq++xTiVgQy6s9nseOuD9pqkUxSN
 ByIDh3iC5jOAEm/IbofSJ6CU37+jWUQo/6ZELc/zWv9a2TaPiP
 3vcAgOYPOHP1VXtIG7fKBZ5WtG9IkZKC1Pw/GLhDuBf6CP3q1C
 qh/J2dtU0bsOyFNH+Xdhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 August 2011, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> np is initialized to the result of calling a function that calls
> of_node_get, so of_node_put should be called before the pointer is dropped.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e,e1,e2;
> @@
> 
> * e = \(of_find_node_by_type\|of_find_node_by_name\)(...)
>   ... when != of_node_put(e)
>       when != true e == NULL
>       when != e2 = e
>   e = e1
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
Acked-by: Arnd Bergmann <arnd@arndb.de>
