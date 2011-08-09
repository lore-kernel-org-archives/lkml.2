Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1HISMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:12:30 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:36759 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751518Ab1HISM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:12:28 -0400
Subject: Re: [PATCH] gianfar: reduce stack usage in gianfar_ethtool.c
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, stufever@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, Wang Shaoyan <wangshaoyan.pt@taobao.com>
In-Reply-To: <1312912774.2547.1.camel@edumazet-laptop>
References: <1312907945-1982-1-git-send-email-wangshaoyan.pt@taobao.com>
	 <1312908784.2371.53.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1312912326.11924.12.camel@Joe-Laptop>
	 <1312912774.2547.1.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 11:12:25 -0700
Message-ID: <1312913545.11924.16.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 19:59 +0200, Eric Dumazet wrote:
> Le mardi 09 août 2011 à 10:52 -0700, Joe Perches a écrit :
> > On Tue, 2011-08-09 at 18:53 +0200, Eric Dumazet wrote:
> > > Le mercredi 10 août 2011 à 00:39 +0800, stufever@gmail.com a écrit :
> > []
> > > > +	if (!local_rqfpr || !local_rqfcr) {
> > > > +		pr_err("Out of memory\n");
> > > 	Please remove this pr_err(), kmalloc() will complain already.
> > Always?
> > I know there's a trace option, but is it always on?
> Yes, unless caller added ___GFP_NOWARN in gfp :
> ptr = kmalloc(size, GFP_KERNEL | ___GFP_NOWARN);

Isn't that true only for slub?

Do you know where this get emitted?
I looked cursorily but I don't see it.

