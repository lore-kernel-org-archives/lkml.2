Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab2ETVCi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 17:02:38 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60328 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab2ETVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 17:02:36 -0400
Date: Sun, 20 May 2012 16:59:52 -0400 (EDT)
Message-Id: <20120520.165952.949615878777060190.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6/exthdrs: strict Pad1 and PadN check
From: David Miller <davem@davemloft.net>
In-Reply-To: <1337515173-23648-1-git-send-email-eldad@fogrefinery.com>
References: <1337515173-23648-1-git-send-email-eldad@fogrefinery.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 20 May 2012 13:59:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Sun, 20 May 2012 13:59:33 +0200

> The following tightens the padding check from commit
> c1412fce7eccae62b4de22494f6ab3ff8a90c0c6 :
> 
> * Take into account combinations of consecutive Pad1 and PadN.
> 
> * Catch the corner case of when only padding is present in the
>   header, when the extention header length is 0 (i.e., 8 bytes).
>   In this case, the header would have exactly 6 bytes of padding:
> 
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> :  Next Header  : Hdr Ext Len=0 :                               :
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                               +
> :                        Padding (Pad1 or PadN)                 :
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

Applied to net-next, thanks a lot.
