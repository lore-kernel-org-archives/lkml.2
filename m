Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab0IOExR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 00:53:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41259 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0IOExQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 00:53:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] update /proc/sys/vm/drop_caches documentation
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lnxninja@linux.vnet.ibm.com
In-Reply-To: <20100915133303.0b232671.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100914234714.8AF506EA@kernel.beaverton.ibm.com> <20100915133303.0b232671.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20100915135016.C9F1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 15 Sep 2010 13:53:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  ==============================================================
> >  
> > diff -puN fs/drop_caches.c~update-drop_caches-documentation fs/drop_caches.c
> > --- linux-2.6.git/fs/drop_caches.c~update-drop_caches-documentation	2010-09-14 15:44:29.000000000 -0700
> > +++ linux-2.6.git-dave/fs/drop_caches.c	2010-09-14 15:58:31.000000000 -0700
> > @@ -47,6 +47,8 @@ int drop_caches_sysctl_handler(ctl_table
> >  {
> >  	proc_dointvec_minmax(table, write, buffer, length, ppos);
> >  	if (write) {
> > +		WARN_ONCE(1, "kernel caches forcefully dropped, "
> > +			     "see Documentation/sysctl/vm.txt\n");
> 
> Documentation updeta seems good but showing warning seems to be meddling to me.

Agreed.

If the motivation is blog's bogus rumor, this is no effective. I easily
imazine they will write "Hey, drop_caches may output strange message, 
but please ignore it!".


	Libenter homines id quod volunt credunt.
		Gaius Julius Caesar "Commentarii de Bello Gallico" 3-18



