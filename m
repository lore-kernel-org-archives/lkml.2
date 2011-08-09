Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab1HIT5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:57:19 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:52621 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750839Ab1HIT5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:57:18 -0400
Subject: Re: [PATCH] gianfar: reduce stack usage in gianfar_ethtool.c
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, stufever@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, Wang Shaoyan <wangshaoyan.pt@taobao.com>
In-Reply-To: <1312914257.2547.10.camel@edumazet-laptop>
References: <1312907945-1982-1-git-send-email-wangshaoyan.pt@taobao.com>
	 <1312908784.2371.53.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1312912326.11924.12.camel@Joe-Laptop>
	 <1312912774.2547.1.camel@edumazet-laptop>
	 <1312913545.11924.16.camel@Joe-Laptop>
	 <1312914257.2547.10.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 12:57:15 -0700
Message-ID: <1312919835.11924.26.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 20:24 +0200, Eric Dumazet wrote:
> Le mardi 09 août 2011 à 11:12 -0700, Joe Perches a écrit :
> > On Tue, 2011-08-09 at 19:59 +0200, Eric Dumazet wrote:
> > > Le mardi 09 août 2011 à 10:52 -0700, Joe Perches a écrit :
> > > > On Tue, 2011-08-09 at 18:53 +0200, Eric Dumazet wrote:
> > > > > Le mercredi 10 août 2011 à 00:39 +0800, stufever@gmail.com a écrit :
> > > > []
> > > > > > +	if (!local_rqfpr || !local_rqfcr) {
> > > > > > +		pr_err("Out of memory\n");
> > > > > 	Please remove this pr_err(), kmalloc() will complain already.

I think this is fine and should be kept until
some general agreement is made that OOM messages
should be removed generically.

If these are really superfluous, which I doubt a
little because these are emitted at different
KERN_<LEVEL>, (the generic one emits at KERN_WARNING),
there are _thousands_ of these OOM errors in drivers/
alone that could be removed.

$ grep -rP --include=*.[ch] \
	"(printk|\b[a-z]+_\w+)\s*\(.*\".*(alloc|mem)" drivers | \
  wc -l
5147

call it 50% false positive, it's still a lot.

I think one more won't hurt for awhile.


