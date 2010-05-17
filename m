Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab0EQKXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:23:19 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:53478 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab0EQKXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:23:17 -0400
Date: Mon, 17 May 2010 12:23:14 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Julia Lawall <julia@diku.dk>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/10] drivers/s390/char: Use kstrdup
Message-ID: <20100517122314.0c639383@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.64.1005142303180.28935@ask.diku.dk>
References: <Pine.LNX.4.64.1005142127100.28935@ask.diku.dk>
	<Pine.LNX.4.64.1005142210320.28935@ask.diku.dk>
	<Pine.LNX.4.64.1005142303180.28935@ask.diku.dk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 23:03:51 +0200 (CEST)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Use kstrdup when the goal of an allocation is copy a string into the
> allocated region.  Additionally drop the now unused variable len.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression from,to;
> expression flag,E1,E2;
> statement S;
> @@
> 
> -  to = kmalloc(strlen(from) + 1,flag);
> +  to = kstrdup(from, flag);
>    ... when != \(from = E1 \| to = E1 \)
>    if (to==NULL || ...) S
>    ... when != \(from = E2 \| to = E2 \)
> -  strcpy(to, from);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Added to git390, thanks Julia.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

