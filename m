Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2GDVpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 17:45:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab2GDVpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 17:45:22 -0400
Date: Wed, 4 Jul 2012 23:45:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lm8333: Fix check ordering
In-Reply-To: <20120704200550.GA13248@core.coreip.homeip.net>
Message-ID: <alpine.LNX.2.00.1207042344570.17304@pobox.suse.cz>
References: <20120704145653.7910.26502.stgit@localhost.localdomain> <20120704200550.GA13248@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2012, Dmitry Torokhov wrote:

> > From: Alan Cox <alan@linux.intel.com>
> > 
> > Fix harmless reference off end of array
> > 
> > Reported-by: <dcb314@hotmail.com>
> > Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?43861
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > ---
> > 
> >  drivers/input/keyboard/lm8333.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/input/keyboard/lm8333.c b/drivers/input/keyboard/lm8333.c
> > index ca168a6..081fd9e 100644
> > --- a/drivers/input/keyboard/lm8333.c
> > +++ b/drivers/input/keyboard/lm8333.c
> > @@ -91,7 +91,7 @@ static void lm8333_key_handler(struct lm8333 *lm8333)
> >  		return;
> >  	}
> >  
> > -	for (i = 0; keys[i] && i < LM8333_FIFO_TRANSFER_SIZE; i++) {
> > +	for (i = 0; i < LM8333_FIFO_TRANSFER_SIZE && keys[i]; i++) {
> >  		pressed = keys[i] & 0x80;
> >  		code = keys[i] & 0x7f;
> >  
> > 
> 
> I believe Jiri has already queued this through trivial tree...

Yup, it's in -next as 954bd6d1c. Thanks,

-- 
Jiri Kosina
SUSE Labs
