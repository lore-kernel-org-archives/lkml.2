Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab2ENWh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:37:27 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:60210 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab2ENWh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:37:26 -0400
Date: Mon, 14 May 2012 18:37:21 -0400 (EDT)
Message-Id: <20120514.183721.1989442389245940694.davem@davemloft.net>
To: JBeulich@suse.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfrm: make xfrm_algo.c a module
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FAA3EAF02000078000826E4@nat28.tlf.novell.com>
References: <4FAA3EAF02000078000826E4@nat28.tlf.novell.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 14 May 2012 15:37:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jan Beulich" <JBeulich@suse.com>
Date: Wed, 09 May 2012 08:53:51 +0100

> By making this a standalone config option (selected as needed),
> selecting CRYPTO from here rather than from XFRM (which is boolean)
> allows the core crypto code to become a module again even when XFRM=y.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
 ...
> @@ -15,9 +15,6 @@
>  #include <linux/crypto.h>
>  #include <linux/scatterlist.h>
>  #include <net/xfrm.h>
> -#if defined(CONFIG_INET_AH) || defined(CONFIG_INET_AH_MODULE) || defined(CONFIG_INET6_AH) || defined(CONFIG_INET6_AH_MODULE)
> -#include <net/ah.h>
> -#endif

This is completely unrelated to the change you are trying to make in
this patch.

It belongs in a separate change.
