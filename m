Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2DMHPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 03:15:52 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34308 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2DMHPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 03:15:50 -0400
Date: Fri, 13 Apr 2012 15:22:50 +0900
From: Simon Horman <horms@verge.net.au>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, wensong@linux-vs.org, ja@ssi.bg,
        kaber@trash.net, davem@davemloft.net, davej@redhat.com,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipvs: Verify that IP_VS protocol has been
 registered
Message-ID: <20120413062250.GA6163@verge.net.au>
References: <1333668273-8873-1-git-send-email-levinsasha928@gmail.com>
 <20120411232243.GB7038@1984>
 <20120411234628.GA7253@1984>
 <CA+1xoqcxggYxb_ha4VdQtCUW-iYeVbaB38mC_pwAzdCf=rS7mQ@mail.gmail.com>
 <20120413041150.GA26149@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413041150.GA26149@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 01:11:50PM +0900, Simon Horman wrote:
> On Fri, Apr 13, 2012 at 02:54:13AM +0200, Sasha Levin wrote:
> > On Thu, Apr 12, 2012 at 1:46 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >> If you return here, I think you'll leave things in inconsistent state,
> > >> ie. the tcp protocol is registered. You have to unregister it before
> > >> leaving.
> > 
> > I thought that the cleanup callback is getting called for failed init
> > calls, if that's not the case then we can probably call it ourselves
> > if any of these failed.
> 
> Good point. In any case, I think that I have found a new problem.

[sni@]

I have confirmed that the cleanup code is called on error, so I think that
your existing patch is fine.

Acked-by: Simon Horman <horms@verge.net.au>

Pablo, please consider taking this change. The other problem I raised,
though related, can be handled separately as it won't occur if the
ftp helper isn't initialised.

