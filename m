Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0GLCTZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:19:25 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35964 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab0GLCTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:19:23 -0400
Subject: Re: [PATCH 1/2] Add a common struct clk
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ben Herrenchmidt <benh@kernel.crashing.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <AANLkTilitnz8eiBclky74FTOeKua3LjM3cbRdfwzkpnW@mail.gmail.com>
References: <1277098513.947165.104554431018.0.gpush@pororo>
	 <1277098513.947633.945838133095.1.gpush@pororo>
	 <AANLkTilitnz8eiBclky74FTOeKua3LjM3cbRdfwzkpnW@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jul 2010 10:19:13 +0800
Message-ID: <1278901153.9235.6.camel@pororo.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MyungJoo,

> > +int clk_enable(struct clk *clk)
> > +{
> > +       int ret = 0;
> > +
> > +       if (!clk->ops->enable)
> > +               return 0;
> 
> Wouldn't it be better (safer?) to check "clk" and "clk->ops" before
> accessing clk->ops->enable?
> For example,
> 
>         if (IS_ERR_OR_NULL(clk))
>                 return -EINVAL;
> 
>         if (!clk->ops || !clk->ops->enable)
>                 return 0;
> 
> Or, do you think it'd be better not to check and save some time?
> 
> Anyway, if we intend to check the input, the patch for the patch
> including kernel/clk.c would be...

I think that we should leave it as-is; although it may be 'safer', it
may mean more subtle bugs can arise because we've been handed an invalid
clock pointer.

I'd rather the code oops on first usage so that the developer realises
that something is broken, rather than fail with an error code.

BTW - nice work on the samsung implementation, I will check it out soon.

Cheers,


Jeremy

