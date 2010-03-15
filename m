Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964957Ab0COOYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:24:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935728Ab0COOYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:24:11 -0400
Date: Mon, 15 Mar 2010 15:24:03 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Sonny Rao <sonnyrao@us.ibm.com>
Cc: Jani Nikula <ext-jani.1.nikula@nokia.com>, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, tklauser@distanz.ch
Subject: Re: [PATCH] powerpc/BSR: fix device_create() return value check
In-Reply-To: <20100311212157.GD5204@us.ibm.com>
Message-ID: <alpine.LNX.2.00.1003151523330.18642@pobox.suse.cz>
References: <1268324153-30345-1-git-send-email-ext-jani.1.nikula@nokia.com> <20100311212157.GD5204@us.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010, Sonny Rao wrote:

> > Use IS_ERR() instead of comparing to NULL.
> > 
> > Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
> > 
> > ---
> > 
> > NOTE: I'm afraid I'm unable to test this; please consider this more a
> > bug report than a complete patch.
> > ---
> >  drivers/char/bsr.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/char/bsr.c b/drivers/char/bsr.c
> > index c02db01..3b31f74 100644
> > --- a/drivers/char/bsr.c
> > +++ b/drivers/char/bsr.c
> > @@ -252,7 +252,7 @@ static int bsr_add_node(struct device_node *bn)
> > 
> >  		cur->bsr_device = device_create(bsr_class, NULL, cur->bsr_dev,
> >  						cur, cur->bsr_name);
> > -		if (!cur->bsr_device) {
> > +		if (IS_ERR(cur->bsr_device)) {
> >  			printk(KERN_ERR "device_create failed for %s\n",
> >  			       cur->bsr_name);
> >  			cdev_del(&cur->bsr_cdev);
> > -- 
> > 1.6.5.2
> > 
> 
> This looks fine to me, good catch.
> 
> Acked-by: Sonny Rao <sonnyrao@us.ibm.com>

Doesn't seem to be present in linux-next as of today, so I have picked it 
up.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
