Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1HIR7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:59:42 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:41259 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab1HIR7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:59:38 -0400
Subject: Re: [PATCH] gianfar: reduce stack usage in gianfar_ethtool.c
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: stufever@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, Wang Shaoyan <wangshaoyan.pt@taobao.com>
In-Reply-To: <1312912326.11924.12.camel@Joe-Laptop>
References: <1312907945-1982-1-git-send-email-wangshaoyan.pt@taobao.com>
	 <1312908784.2371.53.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1312912326.11924.12.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 19:59:34 +0200
Message-ID: <1312912774.2547.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 09 août 2011 à 10:52 -0700, Joe Perches a écrit :
> On Tue, 2011-08-09 at 18:53 +0200, Eric Dumazet wrote:
> > Le mercredi 10 août 2011 à 00:39 +0800, stufever@gmail.com a écrit :
> []
> > > +	if (!local_rqfpr || !local_rqfcr) {
> > > +		pr_err("Out of memory\n");
> > 	Please remove this pr_err(), kmalloc() will complain already.
> 
> Always?
> I know there's a trace option, but is it always on?
> 

Yes, unless caller added ___GFP_NOWARN in gfp :

ptr = kmalloc(size, GFP_KERNEL | ___GFP_NOWARN);



